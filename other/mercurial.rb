require 'formula'

class Mercurial < Formula
  url 'http://mercurial.selenic.com/release/mercurial-1.9.1.tar.gz'
  homepage 'http://mercurial.selenic.com/downloads/'
  md5 '601990cc58af8316af4e1ea63e19d1be'

  def install
    # Make Mercurial into the Cellar.
    # Skip making the docs; depends on 'docutils' module.
    system "make", "PREFIX=#{prefix}", "build"
    system "make", "PREFIX=#{prefix}", "install-bin"
    # Now we have lib/python2.x/site-packages/ with Mercurial
    # libs in them. We want to move these out of site-packages into
    # a self-contained folder. Let's choose libexec.
    libexec.mkpath
    libexec.install Dir["#{lib}/python*/site-packages/*"]

    # Move the hg startup script into libexec too, and link it from bin
    bin.mkpath
    libexec.install HOMEBREW_PREFIX+'share/python'+'hg'
    ln_s libexec+'hg', bin+'hg'

    # Remove the hard-coded python invocation from hg
    inreplace bin+'hg', %r[#!/.*/python], '#!/usr/bin/env python'

    # We now have a self-contained Mercurial install.

    # Install some contribs
    bin.install 'contrib/hgk'

    # Install man pages
    man1.install 'doc/hg.1'
    man5.install ['doc/hgignore.5', 'doc/hgrc.5']
  end
end
