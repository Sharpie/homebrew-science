require 'formula'

class RtmpdumpYle < Formula
  url 'http://users.tkk.fi/~aajanki/rtmpdump-yle/rtmpdump-yle-1.4.2.tar.gz'
  homepage 'http://users.tkk.fi/~aajanki/rtmpdump-yle/index.html'
  md5 '5bdbf955d3b4ddb06eaa13b326d9d80d'

  depends_on 'json-c'

  def install
    # Help the formula find the json-c library
    ENV["INC"] = "-I#{HOMEBREW_PREFIX}/include/json"

    system "make", "SYS=darwin"
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"
  end
end
