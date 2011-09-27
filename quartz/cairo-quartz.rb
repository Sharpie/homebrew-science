require 'formula'

class CairoQuartz < Formula
  homepage 'http://cairographics.org/'
  url 'http://www.cairographics.org/releases/cairo-1.10.2.tar.gz'
  sha1 'ccce5ae03f99c505db97c286a0c9a90a926d3c6e'

  depends_on 'pkg-config' => :build
  depends_on 'pixman'

  keg_only 'This formula builds Cairo for use with Quartz instead of X11, which is experimental.'

  fails_with_llvm 'Gives an LLVM ERROR with Xcode 4 on some CPUs', :build => 2334

  def install
    system './configure', "--prefix=#{prefix}",
                          '--disable-dependency-tracking',
                          '--enable-quartz', '--enable-quartz-font', '--enable-quartz-image',
                          '--disable-xlib', '--without-x'
    system 'make install'
  end
end
