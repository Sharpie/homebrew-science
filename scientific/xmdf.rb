require 'formula'

class Xmdf <Formula
  homepage 'http://www.xmdf.org'
  url 'http://dl.dropbox.com/u/72178/dist/xmdf-unix-1.7.tar.gz'
  md5 'a7d1769044a782b0d2f4c286d831fd9d'

  depends_on 'hdf5'

  depends_on 'cmake' => :build

  def install
    ENV.fortran

    Dir.chdir('build') do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end
  end

  def caveats
    caveats = <<-EOS
This is an unoffical re-packaging of the XMDF source code with a CMake build
system. For the origional souce code and documentation, see:

    http://www.xmdf.org
    EOS
  end
end
