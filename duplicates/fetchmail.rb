require 'formula'

class Fetchmail <Formula
  homepage 'http://www.fetchmail.info/'
  url 'http://prdownload.berlios.de/fetchmail/fetchmail-6.3.19.tar.bz2'
  md5 '64519711c8533f5a34d20c9ff620d880'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
