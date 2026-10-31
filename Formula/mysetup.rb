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
  url "https://mysetup.ai/cli/releases/0.2.4/mysetup-0.2.4-macos-universal.tar.gz"
  sha256 "7fe40466ba074aafebfe5a699fba123f680fbf06229eaf880b61f82aede374de"
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
      url "https://mysetup.ai/cli/releases/0.2.4/mysetup-0.2.4-linux-x86_64.tar.gz"
      sha256 "06ffe0751626ce6ad5470c885e5a3a14131a755b9943e36d22363573c68a5245"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.2.4/mysetup-0.2.4-linux-arm64.tar.gz"
      sha256 "decb07ba36b7bc9cfa6e35c97838c31bbd9d37548b135f22a411fc0f29a82c05"
    end
  end

  def install
    bin.install "mysetup"
  end

  def caveats
    <<~EOS
      Get started:

        mysetup onboard

      Sign in, choose your skills and connect another device.
      Nothing is published, and background sync stays off until you turn it on.

      After upgrading:      mysetup service restart
      Before uninstalling:  mysetup auth logout, then mysetup self uninstall
                            (your skills are never removed)

      All commands: mysetup help
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysetup --version")
    assert_match "\"ok\":true", shell_output("#{bin}/mysetup doctor --offline --json")
    assert_match "\"installed\":false", shell_output("#{bin}/mysetup service status --json")
  end
end
