class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.1.1.tar.gz"
  sha256 "1843caf40fb54bfd746f966fc04fac68613fe8ec2f18b2af99f9d32a40ea0809"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "0145c568d255c20a0f728d14152aad8a83a0ceb25e9f833d016efc57d19191c8" => :el_capitan
    sha256 "077bcf80be63e6da3bdd7699f6b82549d99014210ff8e015e5319234d8a9e75a" => :yosemite
    sha256 "f0c6934dbd1317abae4ef8c0e1440d624dbc7025f06eb1006d654c0c2925cc5b" => :mavericks
    sha256 "4c4db90452fa1858bf990c08b6f047eb1a0549d655142be2e15d3f1c150e12cc" => :x86_64_linux
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "fixup"
  end
end
