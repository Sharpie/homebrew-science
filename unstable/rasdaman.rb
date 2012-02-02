require 'formula'

class Rasdaman < Formula
  homepage 'http://rasdaman.org'
  url 'git://kahlua.eecs.jacobs-university.de/rasdaman.git', :tag => 'v8.3'
  version '8.3'

  head 'git://kahlua.eecs.jacobs-university.de/rasdaman.git'

  depends_on 'postgres'
  depends_on 'netpbm'
  depends_on 'gdal'

  def patches
    # OS X-specific tweaks.
    DATA
  end

  def install
    ENV.x11

    system 'autoreconf', '-fi'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    system "make install"
  end

  def test
    system "start_rasdaman.sh"
    system "stop_rasdaman.sh"
  end
end

__END__
From 2cb21fcf110b336835ef197c5c7df0722cb1e679 Mon Sep 17 00:00:00 2001
From: Charlie Sharpsteen <source@sharpsteen.net>
Date: Thu, 2 Feb 2012 13:31:56 -0800
Subject: [PATCH 1/5] OS X: Remove libcrypt and libnsl from configure

These libraries do not exist on OS X.
---
 configure.ac |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 05c6398..9e42ad8 100755
--- a/configure.ac
+++ b/configure.ac
@@ -31,7 +31,6 @@ AC_CHECK_PROGS(YACC, bison, [${am_missing_run} bison])
 
 # Checks for libraries.
 # FIXME: Replace `main' with a function in `-lcrypt':
-AC_CHECK_LIB([crypt], [main], , [AC_MSG_FAILURE([libcrypt.a not found! Please install.])])
 AC_CHECK_LIB([crypto], [EVP_DigestFinal], , [AC_MSG_FAILURE([libcrypto.a not found! Please install.])])
 # FIXME: Replace `main' with a function in `-ldf':
 #AC_CHECK_LIB([df], [main], , [AC_MSG_FAILURE([libdf.a not found! Please install.])])
@@ -344,9 +343,6 @@ AC_DEFINE([X86]) # Currently, but the code supports multiple platforms
 AC_DEFINE([RASARCHITECTURE], ["X86"])
 AC_DEFINE([RASSCHEMAVERSION], [5])
 AC_DEFINE([NOPRE])
-# if not on DEC Alpha
-BASEDBLDFLAGS+=" -lnsl"
-STATICBASEDBLDFLAGS+=" -lnsl"
 # endif
 AC_DEFINE([NO_in_addr_t])
 BASEDBCXXFLAGS+=" $DBIF_INC "
-- 
1.7.9


From dc59895341c77ad863b999ac409960caa8eb3a0e Mon Sep 17 00:00:00 2001
From: Charlie Sharpsteen <source@sharpsteen.net>
Date: Thu, 2 Feb 2012 13:34:01 -0800
Subject: [PATCH 2/5] Remove EARLY_TEMPLATE from rasql_signal

The signal handlers don't use any templated classes so there is no need to
pull in this header. Also, using this header can lead to templated classes
being defined in both `rasql.o` and `rasql_signal.o` after compilation which
causes the linker to abort with a duplicate symbol error.
---
 applications/rasql/rasql_signal.cc |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/applications/rasql/rasql_signal.cc b/applications/rasql/rasql_signal.cc
index b7b68f4..fe07b19 100644
--- a/applications/rasql/rasql_signal.cc
+++ b/applications/rasql/rasql_signal.cc
@@ -33,11 +33,6 @@
 
 static const char rcsid[] = "@(#)rasodmg/test,ImportOrthoUtil: $Id: rasql_signal.cc,v 1.1 2003/12/27 19:30:23 rasdev Exp $";
 
-#ifdef EARLY_TEMPLATE
-#define __EXECUTABLE__
-#include "raslib/template_inst.hh"
-#endif
-
 #include <iostream>
 #include <string>
 #include <iostream>
-- 
1.7.9


From 0a94fef7c6b62b2278ff1bfcce2fc2cf55d81fea Mon Sep 17 00:00:00 2001
From: Charlie Sharpsteen <source@sharpsteen.net>
Date: Thu, 2 Feb 2012 13:36:48 -0800
Subject: [PATCH 3/5] Fix usage of <iostream> in rasql_signal.cc

Remove a repeated import and use the std namespace so that `endl` and friends
are available.
---
 applications/rasql/rasql_signal.cc |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/applications/rasql/rasql_signal.cc b/applications/rasql/rasql_signal.cc
index fe07b19..75f497f 100644
--- a/applications/rasql/rasql_signal.cc
+++ b/applications/rasql/rasql_signal.cc
@@ -33,7 +33,6 @@
 
 static const char rcsid[] = "@(#)rasodmg/test,ImportOrthoUtil: $Id: rasql_signal.cc,v 1.1 2003/12/27 19:30:23 rasdev Exp $";
 
-#include <iostream>
 #include <string>
 #include <iostream>
 #include <signal.h>
@@ -41,6 +40,8 @@ static const char rcsid[] = "@(#)rasodmg/test,ImportOrthoUtil: $Id: rasql_signal
 #include <strings.h>
 #endif
 
+using namespace std;
+
 #include "rasql_error.hh"
 #include "rasql_signal.hh"
 
-- 
1.7.9


From d096964e44669e23cba73b80dca7a7c52d97ca51 Mon Sep 17 00:00:00 2001
From: Charlie Sharpsteen <source@sharpsteen.net>
Date: Thu, 2 Feb 2012 14:37:38 -0800
Subject: [PATCH 4/5] Fix appending of GDAL flags

When appending flags to existing environment variables, ensure a space is added
for separation.
---
 configure.ac |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 9e42ad8..ca80de2 100755
--- a/configure.ac
+++ b/configure.ac
@@ -66,8 +66,8 @@ if test "$GDAL_CONFIG" = "no" ; then
 fi
 GDAL_LIB=`$GDAL_CONFIG --libs`
 GDAL_INC=`$GDAL_CONFIG --cflags`
-LDFLAGS+=$GDAL_LIB
-CXXFLAGS+=$GDAL_INC
+LDFLAGS+=" $GDAL_LIB"
+CXXFLAGS+=" $GDAL_INC"
 
 
 # Checks for header files.
-- 
1.7.9


From fb107e615afbd165128490a0b4917c10b8f4e85f Mon Sep 17 00:00:00 2001
From: Charlie Sharpsteen <source@sharpsteen.net>
Date: Thu, 2 Feb 2012 14:06:28 -0800
Subject: [PATCH 5/5] OS X: Work around broken svc.h

The header file `svc.h` that is shipped with OS X contains function
declarations that use an ancient style which is not supported by C++ compilers.

**NOTE**

This patch should only be applied on OS X--it will break other systems!
---
 servercomm/rpc/svc.h |  373 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 373 insertions(+), 0 deletions(-)
 create mode 100644 servercomm/rpc/svc.h

diff --git a/servercomm/rpc/svc.h b/servercomm/rpc/svc.h
new file mode 100644
index 0000000..5163ba0
--- /dev/null
+++ b/servercomm/rpc/svc.h
@@ -0,0 +1,373 @@
+/*
+ * Copyright (c) 1999 Apple Computer, Inc. All rights reserved.
+ *
+ * @APPLE_LICENSE_HEADER_START@
+ * 
+ * Portions Copyright (c) 1999 Apple Computer, Inc.  All Rights
+ * Reserved.  This file contains Original Code and/or Modifications of
+ * Original Code as defined in and that are subject to the Apple Public
+ * Source License Version 1.1 (the "License").  You may not use this file
+ * except in compliance with the License.  Please obtain a copy of the
+ * License at http://www.apple.com/publicsource and read it before using
+ * this file.
+ * 
+ * The Original Code and all software distributed under the License are
+ * distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, EITHER
+ * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
+ * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE OR NON- INFRINGEMENT.  Please see the
+ * License for the specific language governing rights and limitations
+ * under the License.
+ * 
+ * @APPLE_LICENSE_HEADER_END@
+ */
+/*
+ * Sun RPC is a product of Sun Microsystems, Inc. and is provided for
+ * unrestricted use provided that this legend is included on all tape
+ * media and as a part of the software program in whole or part.  Users
+ * may copy or modify Sun RPC without charge, but are not authorized
+ * to license or distribute it to anyone else except as part of a product or
+ * program developed by the user.
+ * 
+ * SUN RPC IS PROVIDED AS IS WITH NO WARRANTIES OF ANY KIND INCLUDING THE
+ * WARRANTIES OF DESIGN, MERCHANTIBILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE, OR ARISING FROM A COURSE OF DEALING, USAGE OR TRADE PRACTICE.
+ * 
+ * Sun RPC is provided with no support and without any obligation on the
+ * part of Sun Microsystems, Inc. to assist in its use, correction,
+ * modification or enhancement.
+ * 
+ * SUN MICROSYSTEMS, INC. SHALL HAVE NO LIABILITY WITH RESPECT TO THE
+ * INFRINGEMENT OF COPYRIGHTS, TRADE SECRETS OR ANY PATENTS BY SUN RPC
+ * OR ANY PART THEREOF.
+ * 
+ * In no event will Sun Microsystems, Inc. be liable for any lost revenue
+ * or profits or other special, indirect and consequential damages, even if
+ * Sun has been advised of the possibility of such damages.
+ * 
+ * Sun Microsystems, Inc.
+ * 2550 Garcia Avenue
+ * Mountain View, California  94043
+ *
+ *	from: @(#)svc.h 1.20 88/02/08 SMI 
+ *	from: @(#)svc.h	2.2 88/07/29 4.0 RPCSRC
+ *	$Id: svc.h,v 1.4 2004/11/25 19:41:19 emoy Exp $
+ */
+
+/*
+ * svc.h, Server-side remote procedure call interface.
+ *
+ * Copyright (C) 1984, Sun Microsystems, Inc.
+ */
+
+#ifndef _RPC_SVC_H
+#define _RPC_SVC_H
+#include <sys/cdefs.h>
+
+/*
+ * This interface must manage two items concerning remote procedure calling:
+ *
+ * 1) An arbitrary number of transport connections upon which rpc requests
+ * are received.  The two most notable transports are TCP and UDP;  they are
+ * created and registered by routines in svc_tcp.c and svc_udp.c, respectively;
+ * they in turn call xprt_register and xprt_unregister.
+ *
+ * 2) An arbitrary number of locally registered services.  Services are
+ * described by the following four data: program number, version number,
+ * "service dispatch" function, a transport handle, and a boolean that
+ * indicates whether or not the exported program should be registered with a
+ * local binder service;  if true the program's number and version and the
+ * port number from the transport handle are registered with the binder.
+ * These data are registered with the rpc svc system via svc_register.
+ *
+ * A service's dispatch function is called whenever an rpc request comes in
+ * on a transport.  The request's program and version numbers must match
+ * those of the registered service.  The dispatch function is passed two
+ * parameters, struct svc_req * and SVCXPRT *, defined below.
+ */
+
+enum xprt_stat {
+	XPRT_DIED,
+	XPRT_MOREREQS,
+	XPRT_IDLE
+};
+
+/*
+ * Server side transport handle
+ */
+typedef struct {
+	int		xp_sock;
+	unsigned short		xp_port;	 /* associated port number */
+	struct xp_ops {
+#ifdef __cplusplus
+	    bool_t	(*xp_recv)(...);	 /* receive incomming requests */
+	    enum xprt_stat (*xp_stat)(...); /* get transport status */
+	    bool_t	(*xp_getargs)(...); /* get arguments */
+	    bool_t	(*xp_reply)(...);	 /* send reply */
+	    bool_t	(*xp_freeargs)(...);/* free mem allocated for args */
+	    void	(*xp_destroy)(...); /* destroy this struct */
+#else
+	/* DO NOT REMOVE THE COMMENTED OUT ...: fixincludes needs to see them */
+	    bool_t	(*xp_recv)(/*...*/);	 /* receive incomming requests */
+	    enum xprt_stat (*xp_stat)(/*...*/); /* get transport status */
+	    bool_t	(*xp_getargs)(/*...*/); /* get arguments */
+	    bool_t	(*xp_reply)(/*...*/);	 /* send reply */
+	    bool_t	(*xp_freeargs)(/*...*/);/* free mem allocated for args */
+	    void	(*xp_destroy)(/*...*/); /* destroy this struct */
+#endif
+	} *xp_ops;
+	int		xp_addrlen;	 /* length of remote address */
+	struct sockaddr_in xp_raddr;	 /* remote address */
+	struct opaque_auth xp_verf;	 /* raw response verifier */
+	caddr_t		xp_p1;		 /* private */
+	caddr_t		xp_p2;		 /* private */
+} SVCXPRT;
+
+/*
+ *  Approved way of getting address of caller
+ */
+#define svc_getcaller(x) (&(x)->xp_raddr)
+
+/*
+ * Operations defined on an SVCXPRT handle
+ *
+ * SVCXPRT		*xprt;
+ * struct rpc_msg	*msg;
+ * xdrproc_t		 xargs;
+ * caddr_t		 argsp;
+ */
+#define SVC_RECV(xprt, msg)				\
+	(*(xprt)->xp_ops->xp_recv)((xprt), (msg))
+#define svc_recv(xprt, msg)				\
+	(*(xprt)->xp_ops->xp_recv)((xprt), (msg))
+
+#define SVC_STAT(xprt)					\
+	(*(xprt)->xp_ops->xp_stat)(xprt)
+#define svc_stat(xprt)					\
+	(*(xprt)->xp_ops->xp_stat)(xprt)
+
+#define SVC_GETARGS(xprt, xargs, argsp)			\
+	(*(xprt)->xp_ops->xp_getargs)((xprt), (xargs), (argsp))
+#define svc_getargs(xprt, xargs, argsp)			\
+	(*(xprt)->xp_ops->xp_getargs)((xprt), (xargs), (argsp))
+
+#define SVC_REPLY(xprt, msg)				\
+	(*(xprt)->xp_ops->xp_reply) ((xprt), (msg))
+#define svc_reply(xprt, msg)				\
+	(*(xprt)->xp_ops->xp_reply) ((xprt), (msg))
+
+#define SVC_FREEARGS(xprt, xargs, argsp)		\
+	(*(xprt)->xp_ops->xp_freeargs)((xprt), (xargs), (argsp))
+#define svc_freeargs(xprt, xargs, argsp)		\
+	(*(xprt)->xp_ops->xp_freeargs)((xprt), (xargs), (argsp))
+
+#define SVC_DESTROY(xprt)				\
+	(*(xprt)->xp_ops->xp_destroy)(xprt)
+#define svc_destroy(xprt)				\
+	(*(xprt)->xp_ops->xp_destroy)(xprt)
+
+
+/*
+ * Service request
+ */
+struct svc_req {
+#ifdef __LP64__
+	unsigned int		rq_prog;	/* service program number */
+	unsigned int		rq_vers;	/* service protocol version */
+	unsigned int		rq_proc;	/* the desired procedure */
+#else
+	unsigned long		rq_prog;	/* service program number */
+	unsigned long		rq_vers;	/* service protocol version */
+	unsigned long		rq_proc;	/* the desired procedure */
+#endif
+	struct opaque_auth rq_cred;	/* raw creds from the wire */
+	caddr_t		rq_clntcred;	/* read only cooked cred */
+	SVCXPRT	*rq_xprt;		/* associated transport */
+};
+
+
+/*
+ * Service registration
+ *
+ * svc_register(xprt, prog, vers, dispatch, protocol)
+ *	SVCXPRT *xprt;
+ *	u_long prog;
+ *	u_long vers;
+ *	void (*dispatch)(...); // fixincludes needs the ..., even in a comment
+ *	int protocol;  like TCP or UDP, zero means do not register 
+ */
+__BEGIN_DECLS
+/*
+ * The declaration of scv_register has been modified from the original version
+ * distributed by Apple. The only change is that the function pointer in the
+ * fourth argument has been augmented so that the types of the function
+ * parameters are declared.
+ *
+ * This modification allows C++ compilers to use this header file.
+ *
+ * For reference, the original unmodified declarations appear as comments below
+ * the modified declarations.
+ */
+#ifdef __LP64__
+ extern bool_t	svc_register __P((SVCXPRT *, unsigned int, unsigned int, void (*)(struct svc_req*, SVCXPRT*), int));
+// extern bool_t	svc_register __P((SVCXPRT *, unsigned int, unsigned int, void (*)(), int));
+#else
+ extern bool_t	svc_register __P((SVCXPRT *, unsigned long, unsigned long, void (*)(struct svc_req*, SVCXPRT*), int));
+// extern bool_t	svc_register __P((SVCXPRT *, unsigned long, unsigned long, void (*)(), int));
+#endif
+__END_DECLS
+
+/*
+ * Service un-registration
+ *
+ * svc_unregister(prog, vers)
+ *	u_long prog;
+ *	u_long vers;
+ */
+__BEGIN_DECLS
+#ifdef __LP64__
+extern void	svc_unregister __P((unsigned int, unsigned int));
+#else
+extern void	svc_unregister __P((unsigned long, unsigned long));
+#endif
+__END_DECLS
+
+/*
+ * Transport registration.
+ *
+ * xprt_register(xprt)
+ *	SVCXPRT *xprt;
+ */
+__BEGIN_DECLS
+extern void	xprt_register	__P((SVCXPRT *));
+__END_DECLS
+
+/*
+ * Transport un-register
+ *
+ * xprt_unregister(xprt)
+ *	SVCXPRT *xprt;
+ */
+__BEGIN_DECLS
+extern void	xprt_unregister	__P((SVCXPRT *));
+__END_DECLS
+
+
+
+
+/*
+ * When the service routine is called, it must first check to see if it
+ * knows about the procedure;  if not, it should call svcerr_noproc
+ * and return.  If so, it should deserialize its arguments via 
+ * SVC_GETARGS (defined above).  If the deserialization does not work,
+ * svcerr_decode should be called followed by a return.  Successful
+ * decoding of the arguments should be followed the execution of the
+ * procedure's code and a call to svc_sendreply.
+ *
+ * Also, if the service refuses to execute the procedure due to too-
+ * weak authentication parameters, svcerr_weakauth should be called.
+ * Note: do not confuse access-control failure with weak authentication!
+ *
+ * NB: In pure implementations of rpc, the caller always waits for a reply
+ * msg.  This message is sent when svc_sendreply is called.  
+ * Therefore pure service implementations should always call
+ * svc_sendreply even if the function logically returns void;  use
+ * xdr.h - xdr_void for the xdr routine.  HOWEVER, tcp based rpc allows
+ * for the abuse of pure rpc via batched calling or pipelining.  In the
+ * case of a batched call, svc_sendreply should NOT be called since
+ * this would send a return message, which is what batching tries to avoid.
+ * It is the service/protocol writer's responsibility to know which calls are
+ * batched and which are not.  Warning: responding to batch calls may
+ * deadlock the caller and server processes!
+ */
+
+__BEGIN_DECLS
+extern bool_t	svc_sendreply	__P((SVCXPRT *, xdrproc_t, char *));
+extern void	svcerr_decode	__P((SVCXPRT *));
+extern void	svcerr_weakauth	__P((SVCXPRT *));
+extern void	svcerr_noproc	__P((SVCXPRT *));
+#ifdef __LP64__
+extern void	svcerr_progvers	__P((SVCXPRT *, unsigned int, unsigned int));
+#else
+extern void	svcerr_progvers	__P((SVCXPRT *, unsigned long, unsigned long));
+#endif
+extern void	svcerr_auth	__P((SVCXPRT *, enum auth_stat));
+extern void	svcerr_noprog	__P((SVCXPRT *));
+extern void	svcerr_systemerr __P((SVCXPRT *));
+__END_DECLS
+    
+/*
+ * Lowest level dispatching -OR- who owns this process anyway.
+ * Somebody has to wait for incoming requests and then call the correct
+ * service routine.  The routine svc_run does infinite waiting; i.e.,
+ * svc_run never returns.
+ * Since another (co-existant) package may wish to selectively wait for
+ * incoming calls or other events outside of the rpc architecture, the
+ * routine svc_getreq is provided.  It must be passed readfds, the
+ * "in-place" results of a select system call (see select, section 2).
+ */
+
+/*
+ * Global keeper of rpc service descriptors in use
+ * dynamic; must be inspected before each call to select 
+ */
+#ifdef FD_SETSIZE
+extern fd_set svc_fdset;
+#define svc_fds svc_fdset.fds_bits[0]	/* compatibility */
+#else
+extern int svc_fds;
+#endif /* def FD_SETSIZE */
+
+/*
+ * a small program implemented by the svc_rpc implementation itself;
+ * also see clnt.h for protocol numbers.
+ */
+extern void rpctest_service();
+
+__BEGIN_DECLS
+extern void	svc_getreq	__P((int));
+extern void	svc_getreqset	__P((fd_set *));
+extern void	svc_run		__P((void));
+__END_DECLS
+
+/*
+ * Socket to use on svcxxx_create call to get default socket
+ */
+#define	RPC_ANYSOCK	-1
+
+/*
+ * These are the existing service side transport implementations
+ */
+
+/*
+ * Memory based rpc for testing and timing.
+ */
+__BEGIN_DECLS
+extern SVCXPRT *svcraw_create __P((void));
+__END_DECLS
+
+
+/*
+ * Udp based rpc.
+ */
+__BEGIN_DECLS
+extern SVCXPRT *svcudp_create __P((int));
+extern SVCXPRT *svcudp_bufcreate __P((int, unsigned int, unsigned int));
+__END_DECLS
+
+
+/*
+ * Tcp based rpc.
+ */
+__BEGIN_DECLS
+extern SVCXPRT *svctcp_create __P((int, unsigned int, unsigned int));
+__END_DECLS
+
+/*
+ * Any open file descriptor based rpc.
+ */
+__BEGIN_DECLS
+extern SVCXPRT *svcfd_create __P((int, u_int, u_int));
+__END_DECLS
+
+#endif /* !_RPC_SVC_H */
-- 
1.7.9

