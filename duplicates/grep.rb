require 'formula'

class Grep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftp.gnu.org/gnu/grep/grep-2.9.tar.gz'
  md5 '03e3451a38b0d615cb113cbeaf252dc0'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-nls",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
