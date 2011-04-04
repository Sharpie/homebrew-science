require 'formula'

class TarfileDownloadStrategy < CurlDownloadStrategy
  def stage
    safe_system "/usr/bin/tar xf #{@tarball_path}"
    chdir
  end
end

class G2clib < Formula
  homepage 'http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/'
  url 'http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/g2clib-1.2.2.tar'
  md5 '3c56667423756a1e5aff175b89aec6d3'

  depends_on 'jasper'

  def download_strategy
    TarfileDownloadStrategy
  end

  def install
    ENV.x11

    inreplace 'makefile' do |s|
      s.remove_make_var! 'INC'
      s.remove_make_var! 'CC'
      s.gsub! /CFLAGS=.*/, 'CFLAGS+=$(DEFS) $(CPPFLAGS)'
    end

    system 'make'

    lib.install 'libgrib2c.a'
    include.install 'grib2.h'
  end
end
