require 'formula'

class GtkmmQuartz < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.18/gtkmm-2.18.2.tar.gz'
  homepage 'http://www.gtkmm.org/'
  md5 '746a901f5b15605c51d8a396415c8504'

  depends_on 'pkg-config' => :build
  depends_on 'glibmm'
  depends_on 'libsigc++'

  depends_on 'Sharpie/gtk+-quartz' => :alt
  depends_on 'Sharpie/pangomm-quartz' => :alt

  keg_only 'This formula builds GtkMM for use with Quartz instead of X11, which is experimental.'

  def install
    system './configure', '--disable-dependency-tracking', "--prefix=#{prefix}"
    system 'make install'
  end
end
