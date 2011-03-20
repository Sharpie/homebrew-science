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
diff -u b/Makefile b/Makefile
--- b/Makefile
+++ b/Makefile
@@ -10,20 +10,20 @@
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
@@ -75,7 +75,6 @@
 	params.o\
 	malerts.o\
 	motifutils.o\
-	triangle.o\
 	tritest.o\
 	vedglist.o\
 	vgeometry.o\
@@ -140,7 +139,6 @@
 	params.c\
 	malerts.c\
 	motifutils.c\
-	triangle.c\
 	tritest.c\
 	vedglist.c\
 	vgeometry.c\
@@ -173,21 +171,17 @@
 	patterns.h\
 	special.h\
 	graphics.h\
-	triangle.h\
 	vdefines.h\
 	vdefs.h
 
-all: xmgredit5
+all: xmgredit
 
-xmgredit5: $(OBJS) $(PARSOBJS)
-	$(CC) $(OBJS) $(PARSOBJS) -o xmgredit5 $(LIBS)
+xmgredit: $(OBJS) $(PARSOBJS)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(OBJS) $(PARSOBJS) -o xmgredit $(LIBS)
 
 $(OBJS): defines.h globals.h
 eventproc.c: defines.h globals.h
 
-triangle.o:
-	$(CC) -c -DTRILIBRARY triangle.c
-
 pars.o: pars.y
 
 vers.o: $(SRCS) pars.y
@@ -218,8 +212,8 @@
 	touch rcs
 	grep Id:  Makefile $(SRCS) $(INCS) $(PARSSRCS) > release.tmp
 
-install: xmgredit5
-	cp -p xmgredit5 $(INSTALLDIR)/bin/xmgredit5
+install: xmgredit
+	cp -p xmgredit $(INSTALLDIR)/bin/xmgredit
 
 lint:
 	lint  -axv -wk -Nn10000 -Nd10000 $(SRCS) $(PARSSRCS)
@@ -230,3 +224,3 @@
 clean:
-	/bin/rm *.o xmgredit5
+	/bin/rm *.o xmgredit
 
