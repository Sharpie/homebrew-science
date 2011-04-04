require 'formula'

def fortran?
  ARGV.include? '--enable-fortran'
end

class Jpeg6 <Formula
  url 'http://www.hdfgroup.org/ftp/lib-external/jpeg/src/jpegsrc.v6b.tar.gz'
  md5 '83992a9466af7536da30efe6b51d4064'
  version '6b'
  homepage 'http://www.ijg.org/'
end

class Hdf4 <Formula
  url 'http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-4.2.5.tar.gz'
  md5 '7241a34b722d29d8561da0947c06069f'
  homepage 'http://www.hdfgroup.org'

  depends_on "szip"

  def options
    [
      ['--enable-fortran', 'Build Fortran libraries']
    ]
  end

  def install_wrapper compiler_wrapper
    # The HDF4 compiler wrappers `h4cc` and `h4fc` are expected to be present by
    # some libraries that depend on HDF4---they serve the same purpose as
    # `*-config` scripts for other packages.
    inreplace compiler_wrapper do |s|
      # Reset paths
      s.change_make_var! 'prefix', prefix
      s.change_make_var! 'exec_prefix', prefix
      s.change_make_var! 'libdir', lib
      s.change_make_var! 'includedir', include
      # Remove references to Jpeg6---it gets statically compiled into the HDF4
      # libraries
      s.gsub! /-I[^\s]*\/jpeg6\/include/, ''
      s.gsub! /-L[^\s]*\/jpeg6\/lib/, ''
    end
    bin.install compiler_wrapper
  end

  def install
    ENV.fortran if fortran?

    jpeg_dir = Pathname.new(Dir.pwd) + 'jpeg6'
    Jpeg6.new.brew do
      system "./configure", "--disable-shared"
      system "make"

      jpeg_lib = jpeg_dir + "lib"
      jpeg_include = jpeg_dir + "include"

      jpeg_lib.install Dir['*.a']
      jpeg_include.install Dir['*.h']
    end

    hdf_stage = Pathname.new(Dir.pwd) + 'build'
    args = [
      "--prefix=#{hdf_stage}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-production",
      "--disable-netcdf",
      "--disable-shared",
      "--with-jpeg=#{jpeg_dir}",
      "--with-szlib=#{HOMEBREW_PREFIX}"
    ]
    args << '--disable-fortran' unless fortran?

    system "./configure", *args
    system "make install"

    Dir.chdir hdf_stage do
      # We only install libs, includes and compiler wrapper scripts. Due to the
      # age of this code, most binaries want to use JPEG as a dynamic
      # dependency---but they get a system library that is much newer than
      # expected.  Also, for some strange reason HDF4 builds the `ncdump` and
      # `ncgen` utilities even though `--disable-netcdf` was passed to
      # configure.  Therefore, installing the bin folder is dangerous.
      lib.install Dir['lib/*']
      include.install Dir['include/*']
      install_wrapper Dir['bin/h4cc']
      install_wrapper Dir['bin/h4fc'] if fortran?
    end
  end

  def caveats; <<-EOS.undent
      HDF4 has been superseeded by HDF5.  However, the API changed
      substantially and some programs still require the HDF4 libraries in order
      to function.  This formula only supplies HDF4 static libraries and header
      files as the binary tools and dynamic libraries depend on an outdated
      version of the JPEG library.
    EOS
  end
end
