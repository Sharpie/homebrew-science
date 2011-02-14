require 'formula'

class Nano <Formula
  url 'http://www.nano-editor.org/dist/v2.2/nano-2.2.6.tar.gz'
  homepage 'http://www.nano-editor.org/'
  md5 '03233ae480689a008eb98feb1b599807'

  depends_on 'ncursesw'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--disable-nls",
                          "--enable-utf8"
    system "make install"
  end
end
