require 'formula'

def fortran?
  ARGV.include? '--enable-fortran'
end

class Hdf4 < Formula
  url 'http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-4.2.6.tar.bz2'
  md5 'eed281ded7f81f6ba1a3b1b1d5109bfe'
  homepage 'http://www.hdfgroup.org'

  depends_on 'cmake' => :build
  depends_on 'szip'

  def options
    [
      ['--enable-fortran', 'Build Fortran libraries']
    ]
  end

  def install
    ENV.fortran if fortran?

    args = std_cmake_parameters.split
    args.concat [
      '-DBUILD_SHARED_LIBS=ON',
      '-DBUILD_TESTING=OFF',
      '-DHDF4_BUILD_TOOLS=ON',
      '-DHDF4_BUILD_UTILS=ON',
      '-DHDF4_BUILD_WITH_INSTALL_NAME=ON',
      '-DHDF4_ENABLE_JPEG_LIB_SUPPORT=ON',
      '-DHDF4_ENABLE_NETCDF=ON',
      '-DHDF4_ENABLE_SZIP_ENCODING=ON',
      '-DHDF4_ENABLE_SZIP_SUPPORT=ON',
      '-DHDF4_ENABLE_Z_LIB_SUPPORT=ON',
      "-DSZIP_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include",
      "-DSZIP_LIBRARY_DEBUG=#{HOMEBREW_PREFIX}/lib/libsz.dylib",
      "-DSZIP_LIBRARY_RELEASE=#{HOMEBREW_PREFIX}/lib/libsz.dylib"
    ]
    args.concat %W[-DHDF4_BUILD_FORTRAN=ON -DCMAKE_Fortran_MODULE_DIRECTORY=#{include}] if fortran?

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system 'cmake', '..', *args
      system 'make install'
    end
  end

  def caveats; <<-EOS.undent
      HDF4 has been superseeded by HDF5.  However, the API changed
      substantially and some programs still require the HDF4 libraries in order
      to function.
    EOS
  end
end
