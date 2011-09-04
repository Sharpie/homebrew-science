require 'formula'

class Pngout < Formula
  url 'http://static.jonof.id.au/dl/kenutils/pngout-20110722-darwin.tar.gz'
  homepage 'http://www.advsys.net/ken/util/pngout.htm'
  md5 'ce70a9d70e08b1920e5ac88d130d0eb9'
  version '20110722'

  def install
    bin.install 'pngout'
  end

  def caveats; <<-EOS.undent
    We agreed to the PNGOUT license for you.
    If this is unacceptable you should uninstall.

    License information at:
    http://advsys.net/ken/utils.htm#pngoutkziplicense
    EOS
  end
end
