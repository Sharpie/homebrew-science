require 'formula'

class LibrsvgQuartz < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.34/librsvg-2.34.0.tar.gz'
  homepage 'http://librsvg.sourceforge.net/'
  md5 '3bf6472d65e15cd13230f886da88e913'

  depends_on 'libcroco'

  depends_on 'Sharpie/gtk+-quartz' => :alt

  keg_only 'This formula builds LibRSVG for use with Quartz instead of X11, which is experimental.'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-tools=yes"
    system "make install"
  end
end
