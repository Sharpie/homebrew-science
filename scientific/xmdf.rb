require 'formula'

class Xmdf < Formula
  homepage 'http://www.xmdf.org'
  url 'https://github.com/Sharpie/xmdf-unix.git', :tag => '1.9-2'
  version '1.9-2'

  depends_on 'hdf5'

  depends_on 'cmake' => :build

  def install
    ENV.fortran

    Dir.chdir 'build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end
  end

  def caveats
    caveats = <<-EOS
This is an unoffical re-packaging of the XMDF source code with a CMake build
system. For the original souce code and documentation, see:

    http://www.xmdf.org
    EOS
  end
end
