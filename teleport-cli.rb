# typed: false
# frozen_string_literal: true

class TeleportCli < Formula
  desc "Teleport Enterprise CLI utilities for secure infrastructure access"
  homepage "https://goteleport.com/"
  version "18.3.2"
  license :cannot_represent

  on_macos do
    on_intel do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-amd64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "6cda5e54cfabe708d79b28142cdce590fb3d033fbce3834b891dbc3c5512586e"
    end

    on_arm do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-darwin-arm64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "f05f82bc86086368a3bf9ed6d588469f2d00f28bcf4fa543133eac88057be64c"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-amd64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "df9cd320df5161f41618b16aaba68ea6fa0c929dda2670b6777e6ee34e3facff"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-386-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "3636cce86a905a5cbcc45f1b38cfce79dc0522bae4daa59b5049273f485c47be"
      end
    end

    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm64-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "009359a4f14cba8cd1b48677d807f7764956ccefcba6ea25b2eef788297e78b4"
      else
        url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm-bin.tar.gz",
            verified: "cdn.teleport.dev/"
        sha256 "cc91fac97295b7cdfe59890305dccbd373ef2a2ef76a57172547ac2178b81416"
      end
    end
  end

  # Prevents installation alongside existing cask or official teleport formula
  conflicts_with cask: "superbet-group/tap/teleport-cli",
                 because: <<~EOS
                   both install tsh and tctl binaries.

                   Run the migration script first:
                     bash <(curl -fsSL https://raw.githubusercontent.com/superbet-group/homebrew-tap/master/Casks/cleanup_teleport_cask.sh)

                   Then retry: brew install superbet-group/tap/teleport-cli
                 EOS
  conflicts_with formula: "teleport",
                 because: "both install teleport binaries"

  livecheck do
    url "https://goteleport.com/download/"
    regex(/teleport-ent[._-]v?(\d+(?:\.\d+)+)[._-](?:darwin|linux)/i)
  end

  def install
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
