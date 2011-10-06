require 'formula'

# QCacheGrind: The poor man's version of KCacheGrind

class Qcachegrind < Formula
  homepage 'http://kcachegrind.sourceforge.net/html/Home.html'
  url 'http://kcachegrind.sourceforge.net/kcachegrind-0.7.0.tar.gz'
  md5 '0001385bbc630afa353619de8768e946'

  depends_on 'valgrind'
  depends_on 'qt'
  depends_on 'graphviz'

  def install
    begin
      safe_system "pkg-config Qt3Support --exists"
    rescue
      onoe <<-EOS.undent
        Qt was installed without support for Qt3. QCacheGrind relies on this so
        you will need to re-install Qt:

            brew install qt --with-qt3support

        And go walk the dog because it will take a while.
      EOS
      exit 1
    end

    Dir.chdir 'qcachegrind' do
      system 'qmake -spec macx-g++ -config release qcachegrind.pro'
      system 'make'

      prefix.install 'qcachegrind.app'

      # Write out a command line wrapper script.
      (bin + 'qcachegrind').write <<-EOF.undent
        #!/bin/bash
        open #{prefix}/qcachegrind.app
      EOF
    end
  end
end
