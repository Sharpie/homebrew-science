require 'formula'

class Kindlegen < Formula
  url 'http://s3.amazonaws.com/kindlegen/KindleGen_Mac_i386_v2.zip'
  homepage 'http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000234621'
  md5 '047940fa927751ca426e0cfab0f30815'

  def install
    bin.mkpath

    prefix.install Dir['*']
    chmod 0755, prefix+'kindlegen'
    ln_s prefix+'kindlegen', bin+'kindlegen'
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