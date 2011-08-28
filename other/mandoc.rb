require 'formula'

class Mandoc < Formula
  url 'http://mdocml.bsd.lv/snapshots/mdocml-1.11.6.tar.gz'
  homepage 'http://mdocml.bsd.lv/'
  md5 'bae43efaa8faf9f902bf3c261c72f6ed'

  def install
    system "make PREFIX=#{prefix} MANDIR=#{man} install"
  end
end
