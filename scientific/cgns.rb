require 'formula'

class Cgns < Formula
  homepage 'http://cgns.sourceforge.net'
  url 'http://sourceforge.net/projects/cgns/files/cgnslib_3.1/cgnslib_3.1.tar.gz'
  md5 '6429d5cced489b02c467b56150d3aa8f'

  depends_on 'hdf5'

  depends_on 'cmake' => :build

  def install
    ENV.fortran

    cmake_args = [
      '-DENABLE_FORTRAN=YES',
      '-DENABLE_HDF5=YES',
      '-DHDF5_NEED_ZIP=YES',
      '-DCMAKE_SHARED_LINKER_FLAGS=-lhdf5'
    ]

    cmake_args << '-DENABLE64_BIT' if Hardware.is_64_bit? and MACOS_VERSION >= 10.6

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system "cmake .. #{std_cmake_parameters} #{cmake_args}"
      system 'make install'
    end
  end
end
