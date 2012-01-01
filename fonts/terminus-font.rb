require 'formula'

class TerminusFont < Formula
  homepage 'http://terminus-font.sourceforge.net/'
  url 'http://sourceforge.net/projects/terminus-font/files/terminus-font-4.36/terminus-font-4.36.tar.gz'
  sha256 '7b0dcebd8ef2e36aeeb7fcd97082ad881e95b2871e40c9a6255377bea6bcd345'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--x11dir=#{share}/fonts"
    system "make"
    system "make install fontdir"
    system "mkfontdir #{share}/fonts"
  end
end
