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
  url "https://mysetup.ai/cli/releases/0.1.1/mysetup-0.1.1-macos-universal.tar.gz"
  sha256 "f84f101946173622226e2d42ef11dfd3b439aac7febaaea05347aedf3df07060"
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
      url "https://mysetup.ai/cli/releases/0.1.1/mysetup-0.1.1-linux-x86_64.tar.gz"
      sha256 "c451e5aa2af3a1d19c558351ce43dce57d3aea81b3d41513a4cb9cb7471d8082"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.1.1/mysetup-0.1.1-linux-arm64.tar.gz"
      sha256 "77789d552edd7e6b82d67327242d63d8f96ec387c84ebb13ccdaf58707e9b331"
    end
  end

  def install
    bin.install "mysetup"
  end

  def caveats
    <<~EOS
      The mysetup CLI is a preview. Background sync is off until you turn it on:
        mysetup service enable
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
