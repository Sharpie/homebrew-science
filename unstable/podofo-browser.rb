require 'formula'

class PodofoBrowser < Formula
  homepage 'http://podofo.sourceforge.net'
  # Last version was released in 2007 and is not compatible with current
  # version of the PoDoFo library.
  head 'https://podofo.svn.sourceforge.net/svnroot/podofo/podofobrowser/trunk', :using => :svn

  depends_on 'cmake' => :build

  depends_on 'podofo'
  depends_on 'qt'

  def install
    mkdir 'build'
    Dir.chdir 'build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end
  end
end
