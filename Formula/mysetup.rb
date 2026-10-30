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
  url "https://mysetup.ai/cli/releases/0.2.3/mysetup-0.2.3-macos-universal.tar.gz"
  sha256 "59cf0eeb31281b1dc18c029888dc01b4f4ec758d02a460f4e5853142533c8441"
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
      url "https://mysetup.ai/cli/releases/0.2.3/mysetup-0.2.3-linux-x86_64.tar.gz"
      sha256 "fe8252f3adb330d1844b2bfc083f203e46cb01bedc4205dd37b571aee7d2bf69"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.2.3/mysetup-0.2.3-linux-arm64.tar.gz"
      sha256 "5bbbedab706224aa8a7522b7a54e21175465701b085f316faa12daa62f755c73"
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
