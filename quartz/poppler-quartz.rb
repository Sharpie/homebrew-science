require 'formula'

def glib?; ARGV.include? '--with-glib'; end
def qt?; ARGV.include? '--with-qt4'; end

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.5.tar.gz'
  md5 '448dd7c5077570e340340706cef931aa'
end

class PopplerQuartz < Formula
  url 'http://poppler.freedesktop.org/poppler-0.16.7.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '3afa28e3c8c4f06b0fbca3c91e06394e'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'qt' if qt?

  depends_on 'Sharpie/cairo-quartz'

  keg_only 'This formula builds Poppler for use with Quartz instead of X11, which is experimental.'

  def options
    [
      ["--with-qt4", "Build Qt backend"]
    ]
  end

  def install
    ENV.x11 # For Fontconfig headers

    if qt?
      ENV['POPPLER_QT4_CFLAGS'] = `#{HOMEBREW_PREFIX}/bin/pkg-config QtCore QtGui --libs`.chomp
      ENV.append 'LDFLAGS', "-Wl,-F#{HOMEBREW_PREFIX}/lib"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-xpdf-headers", '--enable-poppler-glib']
    # Explicitly disable Qt if not requested because `POPPLER_QT4_CFLAGS` won't
    # be set and the build will fail.
    args << ( qt? ? '--enable-poppler-qt4' : '--disable-poppler-qt4' )

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make install prefix=#{prefix}"
    end
  end
end
