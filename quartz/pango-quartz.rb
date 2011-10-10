require 'formula'

class PangoQuartz < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.28/pango-1.28.4.tar.bz2'
  sha256 '7eb035bcc10dd01569a214d5e2bc3437de95d9ac1cfa9f50035a687c45f05a9f'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'fontconfig' if MacOS.leopard? # Leopard's fontconfig is too old.

  depends_on 'Sharpie/cairo-quartz' => :alt

  keg_only 'This formula builds Pango for use with Quartz instead of X11, which is experimental.'

  fails_with_llvm 'Undefined symbols when linking', :build => '2326'

  def install
    system './configure', "--prefix=#{prefix}", '--without-x', '--disable-introspection'
    system 'make install'
  end
end
