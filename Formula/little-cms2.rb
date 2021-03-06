class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz"
  sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"

  bottle do
    cellar :any
    sha256 "cf9ce2f00b795f4b8e245a9a5b1650c526503e30b1eb332496bcd1c41568594f" => :el_capitan
    sha256 "57e2eaf3df51fbc1642eebc2a3c9655409948c85565dbbf91168498d21ad7d57" => :yosemite
    sha256 "966dd0d04898592c268ddd31a6cd2657a63e520d504acc7c4c6046c31fed81eb" => :mavericks
    sha256 "a92d6a987f63729a605d0ede42b6275309b3384424f99f1089181b1b570521b8" => :x86_64_linux
  end

  option :universal

  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert File.exist?("out.jpg")
  end
end
