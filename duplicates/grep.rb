require 'formula'

class Grep < Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftpmirror.gnu.org/grep/grep-2.10.tar.xz'
  md5 '709915434d09f5db655e5ebd7fd6bb7f'

  depends_on 'pcre'

  def install
    # find the correct libpcre
    pcre = Formula.factory('pcre')
    ENV.append 'LDFLAGS', "-L#{pcre.lib} -lpcre"
    ENV.append 'CPPFLAGS', "-I#{pcre.include}"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-nls",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
