require 'formula'

# Check to see if Homebrew supports the :alt flag for dependencies.
alt_dep_test = Formula.factory 'gdal'
if not alt_dep_test.external_deps.key? :alt
  onoe <<-EOS
This formula has dependencies which are not in the main Homebrew repository.
These dependencies are specified in such a way that vanilla Homebrew will
refuse to install this formula. A Homebrew branch that supports the external
dependency resolution used by this formula is under development at:

    https://github.com/Sharpie/homebrew/tree/brew-tap

  EOS
  raise "This formula is unsupported and cannot be installed."
end

class HdfEos2 < Formula
  homepage 'http://hdfeos.org'
  url 'ftp://edhs1.gsfc.nasa.gov/edhs/hdfeos/latest_release/HDF-EOS2.17v1.00.tar.Z'
  md5 '425663791aeb9355c6fb9f6650aff0e8'
  version '2.17'

  depends_on 'adamv/hdf4' => :alt

  def patches
    {:p1 => DATA}
  end

  def install
    ENV['CC'] = HOMEBREW_PREFIX + 'bin' + 'h4cc'

    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-szlib=#{HOMEBREW_PREFIX}"

    system "make"

    lib.install 'src/.libs/libhdfeos.a'
    include.install %w[include/HDFEOSVersion.h include/HE2_config.h include/HdfEosDef.h]
  end
end
__END__
Patch to remove "SZIP_CC" a wonky compiler wrapper that never gets generated
which configure then attempts to use and dies.
diff --git a/configure b/configure
index 363be35..84a8af8 100755
--- a/configure
+++ b/configure
@@ -22310,11 +22310,7 @@ echo "$as_me: error: CC is not h4cc" >&2;}
    { (exit 1); exit 1; }; }
     fi
 
-    SZIP_CC=szip_cc
-    cat $PURE_CC | $AWK '{ if ( $0 ~ /^LDFLAGS=\"(.*)/ ) { print substr($0, 1, 9) " -L'$szlib_lib' " substr($0, 10) } else  { print } } ' > $SZIP_CC
-    chmod 755 $SZIP_CC
     saved_CC="$CC"
-    CC=./$SZIP_CC
 
     { echo "$as_me:$LINENO: checking for szlib encoder" >&5
 echo $ECHO_N "checking for szlib encoder... $ECHO_C" >&6; }
@@ -22449,7 +22445,6 @@ fi
 
 
     CC="$saved_CC"
-    rm -f $SZIP_CC
 
     if test ${he2_cv_szlib_functional} = "no"; then
         he2_cv_szlib_can_encode=broken
