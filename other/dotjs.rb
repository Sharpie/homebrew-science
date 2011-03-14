require 'formula'

class Dotjs < Formula
  url 'https://github.com/defunkt/dotjs/tarball/1.3'
  head 'git://github.com/defunkt/dotjs.git'
  homepage 'http://chriswanstrath.com/dotjs/'
  md5 'e8f2d012e136f6c6156a31445593f4d2'

  def install
    # daemon
    bin.install "bin/djsd"

    # chrome
    cp "builds/dotjs.crx", "/tmp/dotjs.crx"
    system "open", "-a", "Google Chrome", "/tmp/dotjs.crx"

    # agent
    agent = File.expand_path "~/Library/LaunchAgents/com.github.dotjs.plist"
    mkdir_p File.dirname(agent)
    cp "com.github.dotjs.plist", agent
    chmod 0644, agent
    system "launchctl", "load", "-w", agent
  end
end
