require 'formula'

# NOTE:
#
# Before this formula can be used, one of the OS X RPC header files must be
# edited:
#
#     /usr/include/rps/svc.h
#
# The declaration for svc_register must be changed from:
#
#     extern bool_t svc_register __P((SVCXPRT *, unsigned int, unsigned int, void (*)(), int));
#
# To:
#
#     extern bool_t  svc_register __P((SVCXPRT *, unsigned int, unsigned int, void (*)(struct svc_req*, SVCXPRT*), int));
#
# Or the header file will be rejected by C++ compilers.
#
class Rasdaman < Formula
  homepage 'http://rasdaman.org'
  # This formula requires a version of the Rasdaman sources which is newer than
  # the last stable release, 8.2.1. Specifically, newer than 29c260d which
  # fixes fatal segfaults in 64 bit binaries. Version f4ea0d6 added a bug to
  # the configure script that prevents it from working due to a missing
  # 'fnmatch_.h' file (which looks like it is placed in the source tree
  # manually by the developers). This leaves 8a81402 as the last "compilable"
  # version.
  url 'git://kahlua.eecs.jacobs-university.de/rasdaman.git', :sha => '8a81402'
  version '8a81402'

  depends_on 'postgres'
  depends_on 'netpbm'

  def patches
    'https://raw.github.com/gist/1354395/79aff3c4e6548703d84c0fe9aa3fdcbb1332410e/rasdaman_os_x.patch'
  end

  def install
    ENV.x11

    system 'autoreconf', '-fi'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Need to switch the compiler for Rasql to Clang, otherwise linking
    # fails:
    #
    #     ld: duplicate symbol r_Ref<r_Object>::is_null() const in
    #     rasql_signal.o and rasql.o
    #
    # Unfortunately, the whole application cannot be built with clang. This
    # will require a version of clang that contains the C++ compiler,
    # `clang++`. Such a version can be obtained using the LLVM formula:
    #
    #     brew install llvm --with-clang
    #
    # And ensuring that the Homebrew bin directory is prepended to the PATH:
    #
    #     export PATH="`brew --prefix`/bin:$PATH"
    inreplace 'applications/rasql/Makefile' do |s|
      s.change_make_var! 'CC', 'clang'
      s.change_make_var! 'CPP', 'clang -E'
      s.change_make_var! 'CXX', 'clang++'
    end

    system "make install"
  end

  def test
    system "start_rasdaman.sh"
    system "stop_rasdaman.sh"
  end
end
