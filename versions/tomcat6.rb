require 'formula'

class Tomcat6 < Formula
  url 'http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.33/bin/apache-tomcat-6.0.33.tar.gz'
  homepage 'http://tomcat.apache.org/'
  md5 '0e86af52d7d31503a98beb04a9d5d8dc'

  skip_clean :all

  keg_only "Some scripts that are installed conflict with other software."

  def install
    rm_rf Dir['bin/*.{cmd,bat]}']
    libexec.install Dir['*']
    (libexec+'logs').mkpath
    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each { |f| ln_s f, bin }
  end

  def caveats; <<-EOS.undent
    Some of the support scripts used by Tomcat have very generic names.
    These are likely to conflict with support scripts used by other Java-based
    server software.

    You can link Tomcat into PATH with:

      brew link tomcat6

    or add #{bin} to your PATH instead.
    EOS
  end
end
