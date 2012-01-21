require 'formula'

class Bison < Formula
  url 'http://ftpmirror.gnu.org/bison/bison-2.5.tar.bz2'
  homepage 'http://www.gnu.org/software/bison/'
  md5 '9dba20116b13fc61a0846b0058fbe004'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
