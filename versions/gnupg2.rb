require 'formula'

class Gnupg2 < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.18.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '5ec2f718760cc3121970a140aeea004b64545c46'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pinentry'
  depends_on 'pth'
  depends_on 'dirmngr' => :optional

  def options
    [['--with-gpg-link', 'Create a symlink from "gpg" to "gpg2"']]
  end

  def install
    (var+'run').mkpath
    inreplace 'common/homedir.c', '/var/run', '#{var}/run'

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"

    ln_s bin+'gpg2', bin+'gpg' if ARGV.include? '--with-gpg-link'
  end
end
