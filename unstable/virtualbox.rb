require 'formula'

# See: http://www.virtualbox.org/wiki/Mac%20OS%20X%20build%20instructions

# Hardening Notes:
#
# Building with hardening is a good idea for security reasons. Unfortunately,
# it is also a pain in the ass. Some resources:
#
# http://thread.gmane.org/gmane.comp.emulators.virtualbox.devel/4468
# http://trac.macports.org/ticket/30992

def x86_64?
  `uname -m`.strip == 'x86_64'
end

# Needs a newer openssl (but maybe not for Lion?)
class OpenSSL < Formula
  url 'http://www.openssl.org/source/openssl-1.0.0e.tar.gz'
  md5 '7040b89c4c58c7a1016c0dfa6e821c86'
  version '1.0.0e'
end

class Virtualbox < Formula
  homepage 'http://www.virtualbox.org/'
  # Using 4.0.12 because I had consistent kernel panics after upgrading to the
  # official (non-homebrewed) 4.1.2 release. 4.0.12 may not work on Lion.
  url 'http://download.virtualbox.org/virtualbox/4.0.12/VirtualBox-4.0.12.tar.bz2'
  md5 '5b39b99c2a36c96a062913e8ac67c60f'

  depends_on "libidl"
  depends_on "qt"

  def patches
    # Allow Lion to boot as a guest OS. Installation is still
    # problematic---best to use a VMWare fusion trial to get through that and
    # convert the VMWare .vmdk to a VirtualBox .vdi. After that, these patches
    # will allow the OS to boot---it will hang for ~half a minute "Waiting for
    # DSMOS".
    'https://raw.github.com/gist/1239064/b8c836567c3fd63619c20858a75e71a93a00272e/VBox_Lion.patch'
  end

  def install
    ENV.deparallelize

    # TODO:
    # Is this required on Lion?
    ssl_dir = Pathname.new(Dir.getwd) + 'openssl'
    OpenSSL.new.brew do
      # OpenSSL uses a Perl "Configure" script which is a steaming pile of fail
      # when another script has to run it.
      config_script = Pathname.new(Dir.getwd) + 'Configure'
      new_config = config_script.readlines
      new_config.slice! 0, 3 # Remove some bullshit from the beginning of the script.
      new_config.insert 0, "#!/usr/bin/env perl -w\n" # Do what should have been done in the first place.
      config_script.unlink
      config_script.write new_config
      config_script.chmod 0755

      system './Configure', *%W[ --prefix=#{ssl_dir} --openssldir=#{ssl_dir}/etc zlib no-shared #{x86_64? ? 'darwin64-x86_64-cc' : 'darwin-i386-cc'} ]

      system 'make'
      system 'make install_sw' # Don't need the docs as this is a disposable static-link library
    end

    # On Snow Leopard and newer, force compilation against the 10.6 SDK
    if MacOS.snow_leopard?
      here = Pathname.new Dir.pwd
      (here + 'LocalConfig.kmk').write <<-EOF.undent
        VBOX_DEF_MACOSX_VERSION_MIN=10.6
        VBOX_DARWIN_NO_COMPACT_LINKEDIT=
        VBOX_MACOS_10_5_WORKAROUND=
      EOF
    end

    qt = Formula.factory 'qt'

    args = ["--disable-hardening",
            "--with-openssl-dir=#{ssl_dir}",
            "--with-qt-dir=#{qt.prefix}",
            "--target-arch=#{x86_64? ? 'amd64' : 'x86'}"]

    system "./configure", *args
    system ". ./env.sh ; kmk"

    # Move all the build outputs into libexec
    libexec.install Dir["out/darwin.*/release/dist/*"]

    app_contents = libexec+"VirtualBox.app/Contents/MacOS/"

    # remove test scripts and files
    #
    # TODO:
    # See hardening notes for ways to avoid building these in the first place
    # by writing to LocalConfig.kmk.
    (app_contents + "testcase").rmtree
    rm Dir.glob(app_contents + "tst*")

    # Slot the command-line tools into bin
    bin.mkpath

    cd prefix do
      %w[ VBoxHeadless VBoxManage VBoxVRDP vboxwebsrv ].each do |c|
        ln_s app_contents + c, bin + c if File.exist? app_contents+c
      end
    end

    # TODO - download guest additions iso & manual and put it in share somewhere?
  end

  def caveats; <<-EOS.undent
    Compiled outputs installed to:
      #{libexec}

    To load the kernerl extensions run:
      #{libexec}/loadall.sh

    Pre-compiled binaries are available from:
      http://www.virtualbox.org/wiki/Downloads

    **NOTE**
    This VirtualBox build is __not hardened__ and shouldn't be allowed anywhere
    near a production environment where hostile code could be run inside the VM.
    EOS
  end
end
