require 'formula'

# NOTE:
#
# Two exciting enhancements in GCC 4.6.0 are currently unavailable.
#
# Link-time optimization (LTO) is broken due to changes in XCode 3.2.6 and 4.0.
# This should be fixed in GCC 4.6.1:
#   http://lists.macosforge.org/pipermail/macports-dev/2011-March/014278.html
#
# (LTO doesn't seem to be fixed even in 4.6.2)
#
# GCC 4.6.0 adds the gccgo compiler for the Go language. However, gccgo "is
# currently known to work on GNU/Linux and RTEMS. Solaris support is in
# progress. It may or may not work on other platforms."
#
# It does not work on OS X. Yet.

def cxx?
  ARGV.include? '--enable-cxx'
end

def fortran?
  ARGV.include? '--enable-fortran'
end

def java?
  ARGV.include? '--enable-java'
end

def objc?
  ARGV.include? '--enable-objc'
end

def objcxx?
  ARGV.include? '--enable-objcxx'
end

def build_everything?
  ARGV.include? '--enable-all-languages'
end

def nls?
  ARGV.include? '--enable-nls'
end

def profiledbuild?
  ARGV.include? '--enable-profiled-build'
end

def dragonegg?
  ARGV.include? '--with-dragonegg'
end

class Ecj < Formula
  # Little Known Fact: ecj, Eclipse Java Complier, is required in order to
  # produce a gcj compiler that can actually parse Java source code.
  url 'ftp://sourceware.org/pub/java/ecj-4.5.jar'
  md5 'd7cd6a27c8801e66cbaa964a039ecfdb'
end

class Dragonegg < Formula
  homepage 'http://dragonegg.llvm.org'
  url 'http://llvm.org/releases/3.0/dragonegg-3.0.tar.gz'
  md5 '3704d215fb4343040eaff66a7a87c63a'
end

class Gcc < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftpmirror.gnu.org/gcc/gcc-4.6.2/gcc-4.6.2.tar.bz2'
  md5 '028115c4fbfb6cfd75d6369f4a90d87e'

  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  depends_on 'llvm' if dragonegg?

  def options
    [
      ['--enable-cxx', 'Build the g++ compiler'],
      ['--enable-fortran', 'Build the gfortran compiler'],
      ['--enable-java', 'Buld the gcj compiler'],
      ['--enable-objc', 'Enable Objective-C language support'],
      ['--enable-objcxx', 'Enable Objective-C++ language support'],
      ['--enable-all-languages', 'Enable all compilers and languages, except Ada'],
      ['--enable-nls', 'Build with natural language support'],
      ['--enable-profiled-build', 'Make use of profile guided optimization when bootstrapping GCC'],
      ['--with-dragonegg', 'Build the LLVM Dragonegg plugin']
    ]
  end

  # Dont strip compilers.
  skip_clean :all

  def gcc_plugins
    share + "gcc-#{version}" + "plugins"
  end

  def install
    # Force 64-bit on systems that use it. Build failures reported for some
    # systems when this is not done.
    ENV.m64 if MacOS.prefer_64_bit?

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete 'LD'

    # This is required on systems running a version newer than 10.6, and
    # it's probably a good idea regardless.
    #
    # https://trac.macports.org/ticket/27237
    ENV.append 'CXXFLAGS', '-U_GLIBCXX_DEBUG -U_GLIBCXX_DEBUG_PEDANTIC'

    gmp = Formula.factory 'gmp'
    mpfr = Formula.factory 'mpfr'
    libmpc = Formula.factory 'libmpc'

    # Sandbox the GCC lib, libexec and include directories so they don't wander
    # around telling small children there is no Santa Claus. This results in a
    # partially keg-only brew following suggestions outlined in the "How to
    # install multiple versions of GCC" section of the GCC FAQ:
    #     http://gcc.gnu.org/faq.html#multiple
    gcc_prefix = prefix + 'gcc'
    gcc_suffix = "-#{version.slice(/\d\.\d/)}"

    args = [
      # Sandbox everything...
      "--prefix=#{gcc_prefix}",
      # ...except the stuff in share...
      "--datarootdir=#{share}",
      # ...and the binaries...
      "--bindir=#{bin}",
      # ...which are tagged with a suffix to distinguish them.
      "--program-suffix=#{gcc_suffix}",
      "--with-gmp=#{gmp.prefix}",
      "--with-mpfr=#{mpfr.prefix}",
      "--with-mpc=#{libmpc.prefix}",
      "--with-system-zlib",
      "--enable-stage1-checking",
      "--enable-plugin",
      "--enable-lto",
      "--disable-multilib"
    ]

    args << '--disable-nls' unless nls?

    if build_everything?
      # Everything but Ada, which requires a pre-existing GCC Ada compiler
      # (gnat) to bootstrap. GCC 4.6.0 add go as a language option, but it is
      # currently only compilable on Linux.
      languages = %w[c c++ fortran java objc obj-c++]
    else
      # The C compiler is always built, but additional defaults can be added
      # here.
      languages = %w[c]

      languages << 'c++' if cxx?
      languages << 'fortran' if fortran?
      languages << 'java' if java?
      languages << 'objc' if objc?
      languages << 'obj-c++' if objcxx?
    end

    if java? or build_everything?
      source_dir = Pathname.new Dir.pwd

      Ecj.new.brew do |ecj|
        # Copying ecj.jar into the toplevel of the GCC source tree will cause
        # gcc to automagically package it into the installation. It *must* be
        # named ecj.jar and not ecj-version.jar in order for this to happen.
        mv "ecj-#{ecj.version}.jar", (source_dir + 'ecj.jar')
      end
    end

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system '../configure', "--enable-languages=#{languages.join(',')}", *args

      if profiledbuild?
        # Takes longer to build, may bug out. Provided for those who want to
        # optimise all the way to 11.
        system 'make profiledbootstrap'
      else
        system 'make bootstrap'
      end

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.

      system 'make install'
    end

    if dragonegg?
      Dragonegg.new.brew do
        # For some reason, a regular 'system make' does not work---the Makefile
        # barfs all over the place due to variables not getting set correctly.
        # It *has* to be run within a bash instance.
        #
        # Frickin' wierd.
        system "/bin/bash -c 'make GCC=#{bin}/gcc#{gcc_suffix}'"
        gcc_plugins.install 'dragonegg.so'

        # Create shell script wrappers that run the compilers with Dragonegg
        # loaded.  These scripts will be named `llvm-compiler-version` since
        # they basically do the same job as the llvm-gcc binaries.
        #
        # gcj is an option, but too buggy at the moment.
        (%w[c c++ fortran] & languages).each do |lang|
          case lang
          when 'c'
            compiler = 'gcc'
          when 'c++'
            compiler = 'g++'
          when 'fortran'
            compiler = 'gfortran'
          end
          compiler += gcc_suffix

          # NOTE:
          # Supposedly Debian/Ubuntu has a Dragonegg package that uses a
          # more sophisticated shell script that makes the wrapped gcc act more
          # like llvm-gcc by translating common arguments on the fly. Example:
          #
          #    llvm-gcc: -emit-llvm => dragonegg: -fplugin-arg-dragonegg-emit-ir
          #
          # Worth checking out to replace the simple wrapper implemented below.
          (bin + "llvm-#{compiler}").write <<-EOF.undent
            #!/bin/sh
            exec #{bin + compiler} -fplugin=#{gcc_plugins}/dragonegg.so "$@"
          EOF
          chmod 0755, bin + "llvm-#{compiler}"
        end
      end
    end
  end
end
