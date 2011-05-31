require 'formula'

class Kindlegen <Formula
  url 'http://s3.amazonaws.com/kindlegen/KindleGen_Mac_i386_v1.2.zip'
  homepage 'http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000234621'
  md5 '2a156d26ef337d3feb1e47fcd1e1e698'
  version '1.2'

  def install
    mkdir bin
    
    prefix.install Dir['*']
    (bin/'kindlegen').make_link(prefix/'kindlegen')
  end

  def caveats; <<-EOS
We agreed to the KindleGen License Agreement for you by downloading KindleGen.
If this is unacceptable you should uninstall.

License information at:
http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000234621

For samples, please check:
  #{prefix}/Sample and #{prefix}/MultimediaSample
EOS
  end
end