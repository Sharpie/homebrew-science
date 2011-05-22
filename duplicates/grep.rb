require 'formula'

class Grep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftp.gnu.org/gnu/grep/grep-2.8.tar.gz'
  md5 'cb2dfc502c5afc7a4a6e5f6cefd6850e'

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
