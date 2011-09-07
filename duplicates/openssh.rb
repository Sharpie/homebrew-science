require 'formula'

class Openssh < Formula
  url 'ftp://ftp.lambdaserver.com/pub/OpenBSD/OpenSSH/portable/openssh-5.9p1.tar.gz'
  homepage 'http://www.openssh.com/'
  sha1 'ac4e0055421e9543f0af5da607a72cf5922dcc56'
  version '5.9p1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--with-libedit", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
