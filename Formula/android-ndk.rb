class AndroidNdk < Formula
  desc "Android native-code language toolset"
  homepage "https://developer.android.com/ndk/index.html"
  if OS.mac?
    url "https://dl.google.com/android/repository/android-ndk-r12b-darwin-x86_64.zip"
    sha256 "2bdef9143a2c7680fcb7c9fd54fe85013d591f106aea43831eba5e13e10db77e"
  elsif OS.linux?
    url "https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip"
    sha256 "eafae2d614e5475a3bcfd7c5f201db5b963cc1290ee3e8ae791ff0c66757781e"
  end

  bottle :unneeded

  # As of r10e, only a 64-bit version is provided
  depends_on :arch => :x86_64
  depends_on "android-sdk" => :recommended

  conflicts_with "crystax-ndk",
    :because => "both install `ndk-build`, `ndk-gdb` and `ndk-stack` binaries"

  def install
    bin.mkpath

    # Now we can install both 64-bit and 32-bit targeting toolchains
    prefix.install Dir["*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-depends ndk-gdb ndk-stack ndk-which].each { |app| bin.install_symlink ndk_exec => app }
  end

  def caveats; <<-EOS.undent
    We agreed to the Android NDK License Agreement for you by downloading the NDK.
    If this is unacceptable you should uninstall.

    License information at:
    https://developer.android.com/sdk/terms.html

    Software and System requirements at:
    https://developer.android.com/sdk/ndk/index.html#requirements

    For more documentation on Android NDK, please check:
      #{prefix}/docs
    EOS
  end

  test do
    (testpath/"test.c").write("int main() { return 0; }")
    cc = Utils.popen_read("#{bin}/ndk-which gcc").strip
    system cc, "-c", "test.c", "-o", "test"
  end
end
