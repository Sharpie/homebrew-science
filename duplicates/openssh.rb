require 'formula'

class Openssh < Formula
  url 'ftp://ftp.lambdaserver.com/pub/OpenBSD/OpenSSH/portable/openssh-5.8p2.tar.gz'
  homepage 'http://www.openssh.com/'
  sha1 '64798328d310e4f06c9f01228107520adbc8b3e5'
  version '5.8p2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--with-libedit", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
