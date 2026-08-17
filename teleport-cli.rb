# typed: false
# frozen_string_literal: true

class TeleportCli < Formula
  desc "Teleport Enterprise CLI utilities for secure infrastructure access"
  homepage "https://goteleport.com/"
  version "18.10.4"
  # To get updated sha256:
  # for platform in darwin-amd64 darwin-arm64 linux-amd64 linux-386 linux-arm64 linux-arm; do
  #  echo -n "$platform: "
  #  VERSION=18.10.4; curl -fsSL "https://cdn.teleport.dev/teleport-ent-v${VERSION}-${platform}-bin.tar.gz.sha256" | awk '{print $1}'
  # done
  license :cannot_represent

  on_macos do
    on_intel do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-amd64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "913b9ffa7018214b2aea0b3ed2cdf45b1c6f26ae439157d693d3e7b58ca83774"
    end

    on_arm do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-arm64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "13ef88f7ab79d0420c427ead5b252d45a5f28ef21531545a8d191c8bb2b4f69b"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-amd64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "2f9e52478cbd9e71c93962a70b71866f82d2872faabc4ee0989a5d99f73fbe87"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-386-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "10941c4cb9846f9b9a243ba5ebe111977a59a0f13f008abaa21b52d313c0a99a"
      end
    end

    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "37a6751a2ab19708427fdb9a4cbb5803136be490e3ce5a1cc9186fcbcb64fe6c"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "695b011b2c1b387ccb07ad9232a4b3cfdb44418faffe950415a5dfa8ded2ae82"
      end
    end
  end

  conflicts_with formula: "teleport",
                 because: "both install teleport binaries"

  livecheck do
    url "https://goteleport.com/download/"
    regex(/teleport-ent[._-]v?(\d+(?:\.\d+)+)[._-](?:darwin|linux)/i)
  end

  def install
    # conflicts_with cask: does not abort installation — check manually
    if OS.mac?
      if (HOMEBREW_PREFIX/"Caskroom/teleport-cli").exist?
        odie <<~EOS
          The teleport-cli cask is currently installed.

          Uninstall it first:
            brew uninstall --cask superbet-group/tap/teleport-cli

          If that leaves behind orphaned files (.app bundles, symlinks, pkgutil records),
          run the cleanup script instead:
            bash <(curl -fsSL https://raw.githubusercontent.com/superbet-group/homebrew-tap/master/Casks/cleanup_teleport_cask.sh)

          Then retry:
            brew install superbet-group/tap/teleport-cli
        EOS
      end
    end

    if OS.mac?
      # macOS: tsh and tctl must run from within their .app bundle due to Hardened Runtime
      # entitlements (com.apple.application-identifier, keychain-access-groups).
      # Extracting the binary standalone causes SIGKILL at launch.
      # Solution: install the full .app bundle to prefix, then symlink the binary.
      %w[tsh.app tctl.app].each do |app|
        odie "Required bundle #{app} not found in archive" unless File.exist?(app)
        prefix.install app
      end
      bin.install_symlink prefix/"tsh.app/Contents/MacOS/tsh" => "tsh"
      bin.install_symlink prefix/"tctl.app/Contents/MacOS/tctl" => "tctl"
    else
      # Linux: plain binaries
      %w[tsh tctl].each do |binary|
        odie "Required binary #{binary} not found in archive" unless File.exist?(binary)
        bin.install binary
      end
    end

    # Optional binaries present on both platforms
    %w[tbot teleport fdpass-teleport].each do |binary|
      bin.install binary if File.exist?(binary)
    end
  end

  def caveats
    <<~EOS
      To login to the Teleport server:

          tsh login --proxy=teleport.happening.dev

      Available commands:
        tsh      - Teleport SSH/Kubernetes client
        tctl     - Teleport admin tool
        tbot     - Teleport Machine ID bot

      To clean up all configuration on uninstall:
        rm -rf ~/.tsh/ ~/.tbot/
    EOS
  end

  test do
    assert_predicate bin/"tsh", :executable?
    assert_predicate bin/"tctl", :executable?
    output = shell_output("#{bin}/tsh version 2>&1", 0)
    assert_match version.to_s, output
  end
end
