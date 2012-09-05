require 'formula'

class SpatialiteGui < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite_gui/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite_gui-1.5.0-stable.tar.gz'
  sha1 'b8cfe3def8c77928f7c9fcc86bae3c99179fa486'

  depends_on 'libspatialite'
  depends_on 'libgaiagraphics'

  depends_on 'wxmac'

  def patches
    # Compatibility fix for wxWidgets 2.9.x and a patch to allow GUI to run
    # without the need for building an app bundle around it.
    [
      'https://gist.github.com/raw/1847199/0001-Use-GetEventHandler-to-call-AddPendingEvent.patch',
      'https://gist.github.com/raw/1847199/0002-Allow-GUI-on-OS-X-without-being-an-app-bundle.patch'
    ]
  end

  def install
    # This lib doesn't get picked up by configure.
    ENV.append 'LDFLAGS', '-lwx_osx_cocoau_aui-2.9'

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
