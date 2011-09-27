require 'formula'

class InkscapeQuartz < Formula
  homepage 'http://www.inkscape.org'
  url 'http://downloads.sourceforge.net/inkscape/inkscape-0.48.2.tar.bz2'
  md5 'f60b98013bd1121b2cc301f3485076ba'

  # Inkscape is a meaty bastard.
  depends_on 'boehmgc'
  depends_on 'boost'
  depends_on 'gsl'
  depends_on 'hicolor-icon-theme'
  depends_on 'little-cms'
  depends_on 'libwpg'

  depends_on 'Sharpie/gtkmm-quartz'
  depends_on 'Sharpie/librsvg-quartz'
  depends_on 'Sharpie/poppler-quartz'

  def install
    ENV.x11
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
