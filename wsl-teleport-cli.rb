# typed: false
# frozen_string_literal: true

# Homebrew Formula for Teleport CLI (WSL/Linux)
# This formula provides the Linux version of Teleport Enterprise Edition
# For macOS, use: brew install --cask superbet-group/tap/teleport-cli

class WslTeleportCli < Formula
  desc "Teleport Enterprise CLI utilities for secure infrastructure access"
  homepage "https://goteleport.com/"
  version "18.3.2"

  on_linux do
    on_intel do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-amd64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "df9cd320df5161f41618b16aaba68ea6fa0c929dda2670b6777e6ee34e3facff"
    end

    on_arm do
      url "https://cdn.teleport.dev/teleport-ent-v#{version}-linux-arm64-bin.tar.gz",
          verified: "cdn.teleport.dev/"
      sha256 "009359a4f14cba8cd1b48677d807f7764956ccefcba6ea25b2eef788297e78b4"
    end
  end

  # Prevent installation on macOS - users should use the cask instead
  def install
    if OS.mac?
      odie <<~EOS
        This formula is for Linux/WSL only.
        On macOS, please use the cask instead:
          brew install --cask superbet-group/tap/teleport-cli
      EOS
    end

    # Check for conflicting teleport installations
    check_conflicts

    # Homebrew strips the top-level directory when extracting, so files are directly accessible
    # Install binaries
    bin.install "tsh"
    bin.install "tctl"
    bin.install "teleport"
    bin.install "tbot"

    # Install examples if they exist
    if File.directory?("examples")
      (share/"teleport").install "examples"
    end
  end

  def check_conflicts
    # Check if other teleport packages are installed
    conflicting_packages = []

    # Check for common teleport binaries in PATH
    %w[tsh tctl teleport tbot].each do |binary|
      next unless which(binary)

      # Get the path and check if it's from another installation
      binary_path = which(binary).to_s
      unless binary_path.include?(HOMEBREW_PREFIX.to_s)
        conflicting_packages << "#{binary} found at #{binary_path}"
      end
    end

    # Warn but don't fail if conflicts are found
    unless conflicting_packages.empty?
      opoo <<~EOS
        \e[1;33mExisting Teleport binaries detected:\e[0m
        #{conflicting_packages.map { |p| "  - #{p}" }.join("\n")}

        These may conflict with this installation.
        Consider removing them before proceeding.
      EOS
    end
  end

  def caveats
    <<~EOS
      ======================================================================
      Teleport Enterprise CLI installed successfully!
      ======================================================================

      For initial authentication to the Superbet Teleport server, run:

          \e[1;32mtsh login --proxy=teleport.happening.dev\e[0m

      Available commands:
        • tsh      - Teleport SSH client
        • tctl     - Teleport admin tool
        • teleport - Teleport daemon
        • tbot     - Teleport Machine ID bot

      Documentation: https://goteleport.com/docs/

      Configuration files are stored in: ~/.tsh/
      ======================================================================
    EOS
  end

  test do
    # Test that binaries are executable and show version
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")
  end
end
