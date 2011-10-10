require 'formula'

class Tcpdump < Formula
  head 'https://github.com/mcr/tcpdump.git'
  homepage 'http://www.tcpdump.org/'

  def install
    ENV.delete 'CFLAGS'
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking", "--disable-smb"
    system "make install"
  end
end
