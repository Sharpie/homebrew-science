require 'formula'

class PkgDownloadStrategy < CurlDownloadStrategy
  def stage
    # The compilers are distributed as a OS X 10.5 package- a single flat xar
    # archive instead of a bundle.
    safe_system '/usr/bin/xar', '-xf', @tarball_path
    chdir

    # Clean up.
    safe_system "mv *.pkg/Payload Payload.gz"
    safe_system "ls | grep -v Payload | xargs rm -r"
  end
end

class AppleGcc42 < Formula
  homepage 'http://r.research.att.com/tools/'
  url 'http://r.research.att.com/tools/gcc-42-5666.3-darwin11.pkg'
  md5 '3ccf46da27aaba17706b420711fb997e'
  version '4.2.1-5666.3'


  def download_strategy
    PkgDownloadStrategy
  end

  # Don't strip compiler binaries.
  skip_clean :all

  def install
    unless MacOS.lion?
      onoe <<-EOS.undent
        The compilers provided by this formula are designed for use on systems
        running OS X 10.7.
      EOS
      exit 1
    end

    safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"

    # Create links for GFortran as this formula is functionally equivalent to
    # the GFotran formula. The only difference is that the GFortran formula
    # tosses out the C compilers.
    safe_system "ln -sf #{bin}/gfortran-4.2 #{bin}/gfortran"
    safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
  end

  def caveats
    <<-EOS.undent
      NOTE:
      This formula provides components that were removed from XCode in the 4.2
      release. There is no reason to install this formula if you are using a
      version of XCode prior to 4.2.

      This formula contains compilers built from Apple's GCC sources, build
      5666.3, available from:

        http://opensource.apple.com/tarballs/gcc

      All compilers have a `-4.2` suffix. A GFortran compiler is also included
      and is the exact same version as the compiler provided by the `gfortran`
      formula in the main repository.
    EOS
  end
end
