class Dhex < Formula
  desc "Ncurses based advanced hex editor featuring diff mode and more"
  homepage "http://www.dettus.net/dhex/"
  url "http://www.dettus.net/dhex/dhex_0.68.tar.gz"
  sha256 "126c34745b48a07448cfe36fe5913d37ec562ad72d3f732b99bd40f761f4da08"

  bottle do
    cellar :any_skip_relocation
    sha256 "78d10f5fc83e4c46f4c6fbe46df834498118b80f190b2b40d1093630be3e039b" => :el_capitan
    sha256 "c6d92d8f4175ecd84be55b071887a97c7924977fbd24509162c956d17d85c84e" => :yosemite
    sha256 "de8a9b04e49e85b4cca75050375724076c9e496a124b0af49006d60fe44dc81f" => :mavericks
    sha256 "159aec24f0a7d68d4284344cc140bfe247a7f7d18a01db6308dd45f55de1e90e" => :mountain_lion
    sha256 "a0b10f1a288319a99a878041ab26d3fcae0cc65ed8b0d198091a31cfdf0db1b4" => :x86_64_linux
  end

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    inreplace "Makefile", "$(DESTDIR)/man", "$(DESTDIR)/share/man"
    bin.mkpath
    man1.mkpath
    man5.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    assert_match("GNU GENERAL PUBLIC LICENSE",
                 pipe_output("#{bin}/dhex -g 2>&1", "", 0))
  end
end
