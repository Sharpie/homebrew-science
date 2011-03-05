require 'formula'

class Openldap <Formula
  url 'ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.24.tgz'
  homepage 'http://www.openldap.org/software/'
  md5 '116fe1e23a7b67686d5e62274367e6c0'

  depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
