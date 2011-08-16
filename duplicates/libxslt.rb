require 'formula'

class Libxslt < Formula
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz'
  homepage 'http://xmlsoft.org/XSLT/'
  md5 'e61d0364a30146aaa3001296f853b2b9'

  keg_only :provided_by_osx

  depends_on 'libxml2'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
