require 'formula'

class Gnupg2 < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.17.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '41ef5460417ca0a1131fc730849fe3afd49ad2de'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pinentry'
  depends_on 'pth'

  def patches
    # fix for building against libgcrypt 1.5.0 from the GnuPG git repository
    # http://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=commit;h=13290b0e0fcf3a493e4848b29329d56b69bc4dd9
    # this will be included in a future release (2.1), but the next stable
    # release is really going to be 2.2, so it will be a while.
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end

__END__
diff --git a/g10/pkglue.c b/g10/pkglue.c
index cbfe21e..5c47511 100644
--- a/g10/pkglue.c
+++ b/g10/pkglue.c
@@ -34,10 +34,10 @@ mpi_from_sexp (gcry_sexp_t sexp, const char * item)
 {
   gcry_sexp_t list;
   gcry_mpi_t data;
-  
+
   list = gcry_sexp_find_token (sexp, item, 0);
   assert (list);
-  data = gcry_sexp_nth_mpi (list, 1, 0);
+  data = gcry_sexp_nth_mpi (list, 1, GCRYMPI_FMT_USG);
   assert (data);
   gcry_sexp_release (list);
   return data;
@@ -293,7 +293,7 @@ pk_decrypt (int algo, gcry_mpi_t * result, gcry_mpi_t * data,
   if (rc)
     return rc;
 
-  *result = gcry_sexp_nth_mpi (s_plain, 0, 0);
+  *result = gcry_sexp_nth_mpi (s_plain, 0, GCRYMPI_FMT_USG);
   gcry_sexp_release (s_plain);
   if (!*result)
     return -1;			/* oops */
