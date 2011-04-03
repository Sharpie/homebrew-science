require 'formula'

class HdfEos5 < Formula
  homepage 'http://hdfeos.org'
  url 'ftp://edhs1.gsfc.nasa.gov/edhs/hdfeos5/latest_release/HDF-EOS5.1.13.tar.Z'
  md5 '9dd44039f3b3e6d232717f0b3554d103'
  version '1.13'

  depends_on 'hdf5'

  def patches
    {:p1 => DATA}
  end

  def install
    ENV['CC'] = HOMEBREW_PREFIX + 'bin' + 'h5cc'

    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-szlib=#{HOMEBREW_PREFIX}"

    system "make install"
    include.install Dir['include/HE5*.h']
  end
end
__END__
Patch to remove "SZIP_CC" a wonky compiler wrapper that never gets generated
which configure then attempts to use and dies.
diff --git a/configure b/configure
index feb161e..b3c3cd1 100755
--- a/configure
+++ b/configure
@@ -22107,11 +22107,7 @@ echo "$as_me: error: CC is not h5cc" >&2;}
    { (exit 1); exit 1; }; }
     fi
 
-    SZIP_CC=szip_cc
-    cat $PURE_CC | $AWK '{ if ( $0 ~ /^LDFLAGS=\"(.*)/ ) { print substr($0, 1, 9) " -L'$szlib_lib' " substr($0, 10) } else  { print } } ' > $SZIP_CC
-    chmod 755 $SZIP_CC
     saved_CC="$CC"
-    CC=./$SZIP_CC
 
     { echo "$as_me:$LINENO: checking for szlib encoder" >&5
 echo $ECHO_N "checking for szlib encoder... $ECHO_C" >&6; }
@@ -22246,7 +22242,6 @@ fi
 
 
     CC="$saved_CC"
-    rm -f $SZIP_CC
 
     if test ${he5_cv_szlib_functional} = "no"; then
         he5_cv_szlib_can_encode=broken
