require 'formula'

class Perl < Formula
  url 'http://www.cpan.org/src/5.0/perl-5.14.1.tar.gz'
  homepage 'http://www.perl.org/'
  md5 '0b74cffa3a10aee08442f950aecbaeec'

  def install
    system("rm -f config.sh Policy.sh");
    system "sh Configure -de -Dprefix=#{prefix} -Dusethreads -Duseshrplib -Duselargefiles"
    system "make install"
  end
end
