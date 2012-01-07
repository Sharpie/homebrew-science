require 'formula'

class Openssl100 < Formula
  url 'http://www.openssl.org/source/openssl-1.0.0f.tar.gz'
  version '1.0.0f'
  homepage 'http://www.openssl.org'
  sha1 'f087190fc7702f328324aaa89c297cab6e236564'

  keg_only :provided_by_osx

  def options
    [['--64-bit', 'Build for the x86_64 architecture.']]
  end

  def install
    args = ["./Configure",
            "--prefix=#{prefix}",
            "--openssldir=#{etc}/openssl",
            "zlib-dynamic", "shared"]

    if ARGV.include? '--64-bit'
      args << 'darwin64-x86_64-cc'
    else
      args << 'darwin-i386-cc'
    end

    system "perl", *args

    ENV.deparallelize
    system "make"
    system "make test"
    system "make install MANDIR=#{man} MANSUFFIX=ssl"
  end
end
