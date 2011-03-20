require 'formula'

class Xmgredit < Formula
  url 'http://dl.dropbox.com/u/72178/dist/xmgredit-5.tar.gz'
  homepage 'http://www.stccmop.org/~pturner/'
  md5 '5fdc737142881868f0e475f86ee3e205'

  depends_on 'lesstif'
  depends_on 'netcdf'
  depends_on 'triangle'

  def patches
    {:p1 => DATA}
  end

  def install
    ENV.x11

    inreplace 'Makefile' do |s|
      s.change_make_var! 'INSTALLDIR', prefix
    end

    bin.mkpath
    system "make install"
  end
end
__END__
Patch to remove Triangle dependencies (as those are handled by the Triangle
formula), to enable NetCDF support and to sort out compiler flags.
diff --git a/Makefile b/Makefile
index eaf69d0..c2f764c 100644
--- a/Makefile
+++ b/Makefile
@@ -10,20 +10,20 @@ INSTALLDIR = /usr/local/ace
 # Uncomment the following 3 defines for netCDF support
 # adjust paths to suit local conditions
 #
-#NETCDF = -DHAVE_NETCDF
-#NETCDFINCLUDES = -I/usr/local/ace/netcdf/include
-#NETCDFLIBS = -L/usr/local/ace/netcdf/lib -lnetcdf
+NETCDFFLAGS=-DHAVE_NETCDF
+NETCDFLIBS=-lnetcdf
+
+TRIANGLEFLAGS=-DDO_TRIANGLE
+TRIAGLELIBS=-ltriangle
 
 ############################################
 # LINUX
-LIBS = -L/usr/X11R6/lib64 -lXm -lXp -lXt -lXext -lXpm -lX11 -lICE -lSM -lm
-INCLUDES = -I/usr/X11R6/include
-CC = gcc -g -O
+LIBS=$(LDFLAGS) -lXm -lXp -lXt -lXext -lXpm -lX11 -lICE -lSM -lm $(NETCDFLIBS) $(TRIAGLELIBS)
+CFLAGS+=$(NETCDFFLAGS) $(TRIANGLEFLAGS)
 
 #################
 ####### End of configuration, no changes should be required below #########
 #################
-CFLAGS = -DDO_TRIANGLE $(INCLUDES)
 
 OBJS = main.o\
 	vers.o\
@@ -75,7 +75,6 @@ OBJS = main.o\
 	params.o\
 	malerts.o\
 	motifutils.o\
-	triangle.o\
 	tritest.o\
 	vedglist.o\
 	vgeometry.o\
@@ -140,7 +139,6 @@ SRCS = main.c\
 	params.c\
 	malerts.c\
 	motifutils.c\
-	triangle.c\
 	tritest.c\
 	vedglist.c\
 	vgeometry.c\
@@ -173,21 +171,17 @@ INCS = motifinc.h\
 	patterns.h\
 	special.h\
 	graphics.h\
-	triangle.h\
 	vdefines.h\
 	vdefs.h
 
 all: xmgredit5
 
 xmgredit5: $(OBJS) $(PARSOBJS)
-	$(CC) $(OBJS) $(PARSOBJS) -o xmgredit5 $(LIBS)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(OBJS) $(PARSOBJS) -o xmgredit5 $(LIBS)
 
 $(OBJS): defines.h globals.h
 eventproc.c: defines.h globals.h
 
-triangle.o:
-	$(CC) -c -DTRILIBRARY triangle.c
-
 pars.o: pars.y
 
 vers.o: $(SRCS) pars.y
