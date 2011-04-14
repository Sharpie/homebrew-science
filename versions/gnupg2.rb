require 'formula'

class Gnupg2 < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.17.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '41ef5460417ca0a1131fc730849fe3afd49ad2de'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pinentry'
  depends_on 'pth'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end
