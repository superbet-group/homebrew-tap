# typed: false
# frozen_string_literal: true

class TeleportCli < Formula
  desc "Teleport Enterprise CLI utilities for secure infrastructure access"
  homepage "https://goteleport.com/"
  version "18.8.1"
  license :cannot_represent

  on_macos do
    on_intel do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-amd64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "f75d36db3e7f7fafa960b15541a2f1edbb83a54346dec656857a24f6c167d226"
    end

    on_arm do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-arm64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "47843b1afc919b62c51e5f03e79a38af7e8632f0f059509db2b44aadaa156872"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-amd64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "1451781b9fc6de369211884c9db14dc3b2efb5e05668f8f7b7cfc88602601435"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-386-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "0be8af38cc9434f64a4dd5b789e400fe817dc14398f86441c6e79ab69e5b2653"
      end
    end

    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "c82cd01817ab4222461d2f320019fd7243bea62716fc3f732d11c71f4ca8e883"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "c3d66129e9c14ddaeec08865e86c06c16146487efbb02a0eb7f61aa105a0a1b3"
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
