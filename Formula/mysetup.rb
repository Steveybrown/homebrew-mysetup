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
  url "https://mysetup.ai/cli/releases/0.1.2/mysetup-0.1.2-macos-universal.tar.gz"
  sha256 "6776866718fe285f4ec8b29721cfb6b728c90f325f5d55a88fd9d1e18a7bb779"
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
      url "https://mysetup.ai/cli/releases/0.1.2/mysetup-0.1.2-linux-x86_64.tar.gz"
      sha256 "43cff9f89c718fb60562af8ab5b7349bf2c213a4af70cf99a64801297361a4a3"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.1.2/mysetup-0.1.2-linux-arm64.tar.gz"
      sha256 "6349d3616fc2bfbd378de8b0edd55569ed26303ab24cfbea0a75f18e6e0850c4"
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
