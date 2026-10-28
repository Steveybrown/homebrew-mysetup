# Homebrew formula for the mysetup CLI. Rendered for each release by
# engine/scripts/release-manifest.ts from engine/packaging/homebrew/mysetup.rb.in in
# github.com/Steveybrown/mysetup.ai; publish the result as Formula/mysetup.rb in the tap
# github.com/mysetupai/homebrew-tap. Do not edit the published copy by hand.
#
# It installs the signed, notarised macOS universal binary (or the static Linux binary)
# from mysetup.ai. There is deliberately no `service` block: background operation is
# opt-in through `mysetup service enable`, which registers the version-independent
# opt/ path, so `brew services` and our agent never both start a host.
class Mysetup < Formula
  desc "Keep your AI agent skills in sync across your computers (preview)"
  homepage "https://mysetup.ai"
  # The macOS universal binary is the default; Linux selects its static build per CPU.
  url "https://mysetup.ai/cli/releases/0.1.3/mysetup-0.1.3-macos-universal.tar.gz"
  sha256 "5adf33c8206a33477252ce37bdcf49f28f454b84e190131067530f7197786c01"
  license :cannot_represent

  livecheck do
    url "https://mysetup.ai/cli/version"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    depends_on macos: :sonoma
  end

  on_linux do
    on_intel do
      url "https://mysetup.ai/cli/releases/0.1.3/mysetup-0.1.3-linux-x86_64.tar.gz"
      sha256 "49baf0dc70aa4f407aaf484417fa7750fd43562cf4a17d94a5172c334a6e49ce"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.1.3/mysetup-0.1.3-linux-arm64.tar.gz"
      sha256 "b1b91ec681803d66709f68db499b13775db0da11e21a078327803a8d962a6b9e"
    end
  end

  def install
    bin.install "mysetup"
  end

  def caveats
    <<~EOS
      Get started with guided private sync:
        mysetup onboard
      It helps you sign in, choose skills and connect another device.
      Nothing is published. Background sync stays off until you choose to enable it.
      For individual commands: mysetup help
      After `brew upgrade mysetup`, run `mysetup service restart` to use the new version.
      Before `brew uninstall mysetup`, run `mysetup auth logout` to sign out, then
      `mysetup self uninstall` to turn background sync off. Uninstalling never removes
      your skills.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysetup --version")
    assert_match "\"ok\":true", shell_output("#{bin}/mysetup doctor --offline --json")
    assert_match "\"installed\":false", shell_output("#{bin}/mysetup service status --json")
  end
end
