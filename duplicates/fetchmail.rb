require 'formula'

class Fetchmail < Formula
  homepage 'http://www.fetchmail.info/'
  url 'http://prdownload.berlios.de/fetchmail/fetchmail-6.3.21.tar.bz2'
  md5 '548f152df27d32b632afa4f1a8a6cd1a'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
