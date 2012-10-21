require 'formula'

class CachedFileDownloadStrategy < CurlDownloadStrategy
  def fetch
    # A download strategy that installs only from the Homebrew cache. This is
    # useful for writing brews that install software for which the source code
    # cannot be freely downloaded.
    ohai "Checking Homebrew cache directory for #{@url}"

    if not @tarball_path.exist?
      onoe <<-EOS
This formula requires source code to be downloaded manually and placed in the
Homebrew cache directory in order for installation to take place. The Homebrew
cache directory is located at:

    #{HOMEBREW_CACHE}

      EOS
      raise "Missing archive file: #{@tarball_path} !"
    end

    return @tarball_path
  end
end

class Adcirc < Formula
  url 'adc49_21.tar.bz2'
  homepage 'http://adcirc.org/'
  sha1 '984c9be240716766c9157fdceab842e594ed1d0a'

  def download_strategy
    CachedFileDownloadStrategy
  end

  depends_on 'netcdf'
  depends_on MPIDependency.new(:cc, :f90)

  def patches
    {:p1 => DATA}
  end

  def install
    ENV.fortran
    # If make runs tasks in parallel, gfortran can't find mod files at the
    # appropriate times.
    ENV.deparallelize
    Dir.chdir "work"

    system "make all NETCDF=enable NETCDFHOME=#{HOMEBREW_PREFIX}"

    programs = %w[adcirc adcprep adcpost padcirc]
    bin.install programs
  end
end
__END__
diff --git a/work/cmplrflags.mk b/work/cmplrflags.mk
index 304e74e..7383018 100644
--- a/work/cmplrflags.mk
+++ b/work/cmplrflags.mk
@@ -723,23 +723,19 @@ endif
 # i386-apple-darwin using intel compilers
 
 ifneq (,$(findstring i386-darwin,$(MACHINE)-$(OS)))
-  PPFC	        := ifort
-  FC	        := ifort
-  PFC	        := mpif77 
-  FFLAGS1       :=  $(INCDIRS) -nowarn -O3    -fixed -132 -check all -traceback -DLINUX -DNETCDF_DEBUG -I .
-# FFLAGS1	:=  $(INCDIRS) -nowarn -O3    -fixed -132 -DIBM -I .
-  FFLAGS2	:=  $(INCDIRS) -nowarn -O3    -fixed -132 -I . 
-  FFLAGS3	:=  $(INCDIRS) -nowarn -O3    -fixed -132 -I .
-  DA  	   	:=  -DREAL8 -DCSCA -DLINUX  
-  DP  	   	:=  -DREAL8 -DCSCA -DLINUX -DCMPI -DNETCDF_DEBUG 
-  DPRE	   	:=  -DREAL8 -DLINUX  
-  IMODS  	:=  -I
-  CC            :=  $(CC)
-  CCBE          :=  $(CC)
-  CFLAGS        :=  $(INCDIRS) $(CFLAGS)
-  LDFLAGS	:=  
-  FLIBS	        :=  
-  MSGLIBS	:=  
+  PPFC	  := gfortran
+  FC	    := gfortran
+  PFC	    := mpif90
+  FFLAGS1 := $(INCDIRS) $(FCFLAGS) -ffree-line-length-none -ffixed-line-length-none
+  FFLAGS2	:= $(FFLAGS1)
+  FFLAGS3	:= $(FFLAGS1)
+  DA  	  := -DREAL8 -DCSCA -DLINUX
+  DP  	  := -DREAL8 -DCSCA -DLINUX -DCMPI -DNETCDF_DEBUG
+  DPRE	  := -DREAL8 -DLINUX
+  IMODS  	:= -I
+  CCBE    := $(CC)
+  FLIBS	  := -lnetcdff
+  MSGLIBS	:=
   $(warning (INFO) Corresponding machine found in cmplrflags.mk.)
   ifneq ($(FOUND),TRUE)
      FOUND := TRUE

diff --git a/metis/Lib/timing.c b/metis/Lib/timing.c
index 49e9e6a..aa637d9 100755
--- a/metis/Lib/timing.c
+++ b/metis/Lib/timing.c
@@ -17,11 +17,13 @@
 #include <time.h>
 
 /* Needed on modern Linux platforms cause' they don't listen to -D__USE_BSD*/
+#ifndef __APPLE__
 struct timezone
   {
     int tz_minuteswest;         /* Minutes west of GMT.  */
     int tz_dsttime;             /* Nonzero if DST is ever in effect.  */
   };
+#endif
 
 
 
