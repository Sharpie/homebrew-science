require 'formula'

class Tk < Formula
  url 'http://sourceforge.net/projects/tcl/files/Tcl/8.5.9/tk8.5.9-src.tar.gz'
  homepage 'http://www.tcl.tk/'
  md5 '7cdeb9feb61593f58a0ae61f2497580e'
  version '8.5.9'

  # must use a Homebrew-built Tcl since versions must match
  depends_on 'tcl'

  def options
    [['--enable-threads', 'Build with multithreading support'],
     ['--enable-aqua', 'Build with Aqua support']]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-tcl=#{HOMEBREW_PREFIX}/lib"]
    args << "--enable-threads" if ARGV.include? "--enable-threads"
    args << "--enable-aqua" if ARGV.include? "--enable-aqua"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

    Dir.chdir 'unix'

    # required to build Aqua support
    inreplace 'Makefile.in' do |s|
      s.change_make_var! "REZ_SWITCHES", "@REZ_FLAGS@ -i $(GENERIC_DIR) " +
                         "-i $(TCL_GENERIC_DIR) -i #{HOMEBREW_PREFIX}/include"
    end

    # so we can find the necessary Tcl headers
    ENV.append 'CFLAGS', "-I#{HOMEBREW_PREFIX}/include"

    system "./configure", *args
    system "make"
    system "make install"

    ln_s bin+'wish8.5', bin+'wish'
  end
end
