require 'formula'

class GtkxQuartz < Formula
  homepage 'http://www.gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.6.tar.bz2'
  sha256 '6f45bdbf9ea27eb3b5f977d7ee2365dede0d0ce454985680c26e5210163bbf37'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  depends_on 'Sharpie/pango-quartz' => :alt

  keg_only 'This formula builds Gtk+ for use with Quartz instead of X11, which is experimental.'

  fails_with_llvm 'Undefined symbols when linking', :build => '2326' unless MacOS.lion?

  def install
    ENV.append 'LDFLAGS', '-framework Carbon -framework Cocoa'

    system './configure', "--prefix=#{prefix}",
                          '--disable-debug', '--disable-dependency-tracking',
                          '--disable-glibtest', '--with-gdktarget=quartz', '--disable-introspection'
    system 'make install'
  end

  def test
    system '#{bin}/gtk-demo'
  end
end
