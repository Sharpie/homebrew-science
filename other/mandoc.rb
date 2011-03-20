require 'formula'

class Mandoc < Formula
  url 'http://mdocml.bsd.lv/snapshots/mdocml-1.10.9.tar.gz'
  homepage ''
  md5 '86395489bc215a6a764c760845a05f8e'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "MANDIR", man
    end
    system "make"
    system "make install"
  end
end
