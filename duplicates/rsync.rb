require 'formula'

class Rsync < Formula
  url 'http://rsync.samba.org/ftp/rsync/src/rsync-3.0.8.tar.gz'
  homepage 'http://rsync.samba.org/'
  md5 '0ee8346ce16bdfe4c88a236e94c752b4'

  depends_on 'libiconv'

  def patches
    base = "http://gitweb.samba.org/?p=rsync-patches.git;a=blob_plain;hb=v3.0.8;f="
    ["#{base}fileflags.diff", "#{base}crtimes.diff", "#{base}hfs-compression.diff"]
  end

  def install
    system "./prepare-source"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-rsyncd-conf=#{prefix}/etc/rsyncd.conf",
                          "--enable-ipv6"
    system "make"
    system "make install"
  end
end
