require 'formula'

class FlexSdk < Formula
  url 'http://fpdownload.adobe.com/pub/flex/sdk/builds/flex4.5/flex_sdk_4.5.1.21328.zip'
  homepage 'http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK'
  md5 '55a59986092195a88cfe7b5796ec8619'

  def install
    libexec.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To use the SDK you will need to:

    (a) add the bin folder to your $PATH:
      #{libexec}/bin

    (b) set $FLEX_HOME:
      export FLEX_HOME=#{libexec}

    (c) add the tasks jar to ANT:
      mkdir -p ~/.ant/lib
      ln -s #{libexec}/ant/lib/flexTasks.jar ~/.ant/lib
    EOS
  end
end
