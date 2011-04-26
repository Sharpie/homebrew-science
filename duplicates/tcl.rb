require 'formula'

class Tcl < Formula
  url 'http://sourceforge.net/projects/tcl/files/Tcl/8.5.9/tcl8.5.9-src.tar.gz'
  homepage 'http://www.tcl.tk/'
  md5 '8512d8db3233041dd68a81476906012a'
  version '8.5.9'

  def options
    [['--enable-threads', 'Build with multithreading support']]
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-threads" if ARGV.include? "--enable-threads"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

    Dir.chdir 'unix'

    system "./configure", *args
    system "make"
    system "make test"
    system "make install"
    system "make install-private-headers" # so we can build extensions, like Tk
  end
end
