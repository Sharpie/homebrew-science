require 'formula'

class Openssl < Formula
  url 'http://www.openssl.org/source/openssl-1.0.0f.tar.gz'
  version '1.0.0f'
  homepage 'http://www.openssl.org'
  sha1 'f087190fc7702f328324aaa89c297cab6e236564'

  keg_only :provided_by_osx

  def install
    system "./config", "--prefix=#{prefix}",
                       "--openssldir=#{etc}/openssl",
                       "zlib-dynamic", "shared"

    ENV.deparallelize
    system "make"
    system "make test"
    system "make install MANDIR=#{man} MANSUFFIX=ssl"
  end
end
