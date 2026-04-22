# typed: false
# frozen_string_literal: true

class TeleportCli < Formula
  desc "Teleport Enterprise CLI utilities for secure infrastructure access"
  homepage "https://goteleport.com/"
  version "18.7.4"
  license :cannot_represent

  on_macos do
    on_intel do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-amd64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "21c99b309c1ac6fe812176b7e9f7c9998f138df616a1517fb7406587bde61577"
    end

    on_arm do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-arm64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "6cf29bceb34655905481f7c34f6d5204bd792b70f15b1c6c839721840cb57480"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-amd64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "3bdc012b48aeda622277e60229fa1ba49809c72d20fc6ccfe136aeeeaded6bc7"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-386-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "6320e731752d70ba21bafebecfa318c63be13996f5f6de0c59b6a269d67ce1a0"
      end
    end

    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "37e353ecdf57828045d12aaa6db6745b191a3dcaa7058fe3eee8b7da369a65aa"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "749e703a6e86d2e991543ed5499333574429eeda20e9432ae68c068d9e0e29c9"
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
