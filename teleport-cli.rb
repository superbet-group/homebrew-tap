# typed: false
# frozen_string_literal: true

class TeleportCli < Formula
  desc "Teleport Enterprise CLI utilities for secure infrastructure access"
  homepage "https://goteleport.com/"
  version "18.11.10"
  # To get updated sha256:
  # for platform in darwin-amd64 darwin-arm64 linux-amd64 linux-386 linux-arm64 linux-arm; do
  #  echo -n "$platform: "
  #  VERSION=18.11.10; curl -fsSL "https://cdn.teleport.dev/teleport-ent-v${VERSION}-${platform}-bin.tar.gz.sha256" | awk '{print $1}'
  # done
  license :cannot_represent

  on_macos do
    on_intel do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-amd64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "7b92b1fb20f01429c1e29c99a062108ff9c1644c4dd919c9a07ea3580b148f8f"
    end

    on_arm do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-arm64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "152bb2705b0fe81930ebeb99027ee1277a73450b1628876bc4f30f41ba3b634f"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-amd64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "1468b60b1ad2b166bb08693a2f9eb3f3efdd8b623e195590d837f14d23183a9d"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-386-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "8d6638c0543f9b8c9386e5b7a9f873a74e650f52deed608721f1535176c0fcb3"
      end
    end

    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "1f108ace453f91bd586c5e498a336568529ba48a2011ac320721f89603fda1e6"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "79a6fa7a9264faaa76fb852b0b9c700981d9532b6c1aeea0329857bbfb02462c"
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
