require 'formula'

class RtmpdumpYle < Formula
  url 'http://users.tkk.fi/~aajanki/rtmpdump-yle/rtmpdump-yle-1.4.3.tar.gz'
  homepage 'http://users.tkk.fi/~aajanki/rtmpdump-yle/index.html'
  md5 'cf82a72eac3d839b11bd93ce426e6648'

  depends_on 'json-c'

  def install
    # Help the formula find the json-c library
    ENV["INC"] = "-I#{HOMEBREW_PREFIX}/include/json"

    system "make", "SYS=darwin"
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"
  end
end
