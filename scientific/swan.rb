require 'formula'

class Swan <Formula
  homepage 'http://swanmodel.sourceforge.net/'
  url 'http://swanmodel.sourceforge.net/download/zip/swan4081.tar.gz'
  version '40.81'
  md5 'efb8fd76f87f46a422ad2009e407831d'

  depends_on 'open-mpi' if ARGV.include? '--enable-mpi'

  depends_on 'gfortran' => :build

  def options
    [
      ['--enable-mpi', 'Parallelize the SWAN model using OpenMPI'],
      ['--enable-omp', 'Parallelize the SWAN model using OpenMP']
    ]
  end

  def install
    # If things aren't built one after the other, gfortran gets confused about
    # missing .mod files.
    ENV.deparallelize

    # Generate SWAN Configuration
    system 'make config'

    # Edit SWAN configuration
    inreplace 'macros.inc' do |s|
      s.change_make_var! 'F90_SER', 'gfortran'
      s.change_make_var! 'F90_OMP', 'gfortran'
      s.change_make_var! 'F90_MPI', 'mpif90'
      s.change_make_var! 'FLAGS_OPT', ENV['CFLAGS']
      s.change_make_var! 'FLAGS90_MSC', '-ffree-line-length-none'
      s.remove_make_var! 'FLAGS_MSC'
      s.change_make_var! 'FLAGS_OMP', '-fopenmp' if ARGV.include? '--enable-omp'
    end

    if ARGV.include? '--enable-mpi'
      system 'make mpi'
    elsif ARGV.include? '--enable-omp'
      system 'make omp'
    else
      system 'make ser'
    end

    programs = [
      'swanrun',
      'swan.exe',
      'hcat.exe'
    ]

    # Set swanrun script to be executable.
    system 'chmod', '755', 'swanrun'

    bin.install programs
  end
end
