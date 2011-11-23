require 'formula'

class Groff < Formula
  url 'http://ftpmirror.gnu.org/groff/groff-1.21.tar.gz'
  md5 '8b8cd29385b97616a0f0d96d0951c5bf'
  homepage 'http://www.gnu.org/software/groff/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-x"
    system "make"
    system "make install"
  end
end
