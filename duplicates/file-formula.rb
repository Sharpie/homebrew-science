require 'formula'

# "File" is a reserved class name
class FileFormula < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.08.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  md5 '6a2a263c20278f01fe3bb0f720b27d4e'
  head 'git://github.com/glensc/file.git'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

