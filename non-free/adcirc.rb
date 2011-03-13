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
  url 'adc49_21.tar.gz'
  homepage 'http://adcirc.org/'
  md5 'e3d3717fc0fa2b540d3d8d88a017a224'

  def download_strategy
    CachedFileDownloadStrategy
  end

  depends_on 'open-mpi'

  def patches
    {:p1 => DATA}
  end

  def install
    ENV.fortran
    # If make runs tasks in parallel, gfortran can't find mod files at the
    # appropriate times.
    ENV.deparallelize
    Dir.chdir "work"

    system 'make all'

    programs = [
      'adcirc',
      'adcprep',
      'adcpost',
      'padcirc'
    ]

    bin.install programs
  end
end
__END__
Patch to build ADCIRC using Homebrew. Needs to be replaced by an `inreplace`
operation, but inreplace cannot deal with ':='.
diff --git a/work/cmplrflags.mk b/work/cmplrflags.mk
index cfd75c4..c99454f 100644
--- a/work/cmplrflags.mk
+++ b/work/cmplrflags.mk
@@ -810,21 +810,17 @@ endif
 # i386-apple-darwin using intel compilers
 
 ifneq (,$(findstring i386-darwin,$(MACHINE)-$(OS)))
-  PPFC	        := ifort
-  FC	        := ifort
-  PFC	        := mpif77 
-  FFLAGS1       :=  $(INCDIRS) -nowarn -O3    -fixed -132 -check all -traceback -DLINUX -DNETCDF_DEBUG -I .
-# FFLAGS1	:=  $(INCDIRS) -nowarn -O3    -fixed -132 -DIBM -I .
-  FFLAGS2	:=  $(INCDIRS) -nowarn -O3    -fixed -132 -I . 
-  FFLAGS3	:=  $(INCDIRS) -nowarn -O3    -fixed -132 -I .
+  PPFC	        := gfortran
+  FC	        := gfortran
+  PFC	        := mpif90
+  FFLAGS1       :=  $(INCDIRS) $(CFLAGS) -ffree-line-length-none -ffixed-line-length-none
+  FFLAGS2	:=  $(FFLAGS1)
+  FFLAGS3	:=  $(FFLAGS1)
   DA  	   	:=  -DREAL8 -DCSCA -DLINUX  
   DP  	   	:=  -DREAL8 -DCSCA -DLINUX -DCMPI -DNETCDF_DEBUG 
   DPRE	   	:=  -DREAL8 -DLINUX  
   IMODS  	:=  -I
-  CC            :=  gcc  
   CCBE          :=  $(CC)
-  CFLAGS        :=  $(INCDIRS) -O3 -DLINUX
-  LDFLAGS	:=  
   FLIBS	        :=  
   MSGLIBS	:=  
   $(warning (INFO) Corresponding machine found in cmplrflags.mk.)
