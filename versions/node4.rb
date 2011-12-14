require 'formula'

class Node4 < Formula
  url 'http://nodejs.org/dist/node-v0.4.12.tar.gz'
  homepage 'http://nodejs.org/'
  md5 'a6375eaa43db5356bf443e25b828ae16'

  head 'https://github.com/joyent/node.git'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.leopard?

  fails_with_llvm :build => 2326

  # Stripping breaks dynamic loading
  skip_clean :all

  def options
    [["--debug", "Build with debugger hooks."]]
  end

  def install
    inreplace 'wscript' do |s|
      s.gsub! '/usr/local', HOMEBREW_PREFIX
      s.gsub! '/opt/local/lib', '/usr/lib'
    end

    args = ["--prefix=#{prefix}"]
    args << "--debug" if ARGV.include? '--debug'

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    For node to pick up installed libraries, add this to your profile:
      export NODE_PATH=#{HOMEBREW_PREFIX}/lib/node_modules
    EOS
  end
end
