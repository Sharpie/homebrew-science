require 'formula'

class SigningParty < Formula
  url 'http://ftp.debian.org/debian/pool/main/s/signing-party/signing-party_1.1.3.orig.tar.gz'
  homepage 'http://pgp-tools.alioth.debian.org/'
  md5 '7d0207ce9415c1687b610be14da0b048'

  depends_on 'gnupg' unless system "/usr/bin/which -s gpg"
  depends_on 'dialog'
  depends_on 'qprint'
  depends_on 'MIME::Tools' => :perl
  depends_on 'Text::Template' => :perl
  depends_on 'Text::Iconv' => :perl
  depends_on 'GnuPG::Interface' => :perl

  skip_clean 'lib/gpgdir'

  def install
    doc.install 'README'

    chdir 'caff' do
      inreplace 'caffrc.sample', '/usr/share/doc/signing-party/caff', doc
      system "make"
      man1.install Dir['*.1']
      bin.install 'caff'
      (doc+'caff').install Dir['README*', 'caffrc.sample']
    end

    chdir 'gpg-mailkeys' do
      inreplace 'gpg-mailkeys', %q[`getent passwd $USER | cut -d: -f5 | cut -d, -f1`],
        %q[`dscl . -read /Users/${USER} | tail -n 5 | head -n 1 | awk '{ print $1 " " $2 }'`]
      bin.install 'gpg-mailkeys'
      man1.install 'gpg-mailkeys.1'
      (doc+'gpg-mailkeys').install ['README', 'example.gpg-mailkeysrc']
    end

    chdir 'gpg-key2ps' do
      system "make"
      man1.install 'gpg-key2ps.1'
      bin.install 'gpg-key2ps'
      (doc+'key2ps').install 'README'
    end

    chdir 'gpgdir' do
      inreplace 'install.pl' do |s|
        s.gsub! "'/usr/lib/gpgdir'", "'#{HOMEBREW_PREFIX}/gpgdir'"
        s.gsub! "$config_homedir = ''", "$config_homedir = '#{prefix}'"
      end

      system "./install.pl --Skip-mod-install"
      man1.install 'gpgdir.1'
      doc.install 'README'
    end

    chdir 'gpglist' do
      system "make"
      bin.install 'gpglist'
      man1.install 'gpglist.1'
    end

    chdir 'gpgsigs' do
      system "make"
      man1.install 'gpgsigs.1'
      bin.install ['gpgsigs', 'gpgsigs-eps-helper']
      (doc+'gpgsigs').install Dir['gpgsigs-lt2k5*.txt']
    end

    chdir 'gpgparticipants' do
      bin.install 'gpgparticipants'
      man1.install 'gpgparticipants.1'
    end

    chdir 'gpgwrap' do
      system "make"
      man1.install 'doc/gpgwrap.1'
      bin.install 'bin/gpgwrap'
    end

    chdir 'keyanalyze' do
      system "make"
      bin.install ['keyanalyze', 'process_keys', 'pgpring/pgpring']
      man1.install ['keyanalyze.1', 'process_keys.1', 'pgpring/pgpring.1']
    end

    chdir 'keylookup' do
      bin.install 'keylookup'
      man1.install 'keylookup.1'
    end

    chdir 'sig2dot' do
      bin.install 'sig2dot'
      man1.install 'sig2dot.1'
      (doc+'sig2dot').install 'README.sig2dot'
    end

    chdir 'springgraph' do
      bin.install 'springgraph'
      man1.install 'springgraph.1'
      (doc+'springgraph').install 'README.springgraph'
    end
  end

  def caveats; <<-EOS.undent
    The 'gpgdir' script may require the installation of additional Perl modules.
    EOS
  end
end
