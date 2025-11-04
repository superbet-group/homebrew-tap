require_relative "custom_download_strategy"
class ObservabilityCli < Formula
  desc "Application Observability CLI for Superbet Group"
  homepage "https://github.com/superbet-group/observability.application.observability-cli"
  version "1.5.3"

  @archive_file = nil
  @sha256_checksum = nil
  on_macos do
    if Hardware::CPU.arm?
      @archive_file = "observability-cli-macos-arm64.tar.gz"
      @sha256_checksum = "55e7730fba9d50f3e2e99c0cec8191ed12e373d7e534033a3582aaaa59839407"
    elsif Hardware::CPU.intel?
      @archive_file = "observability-cli-macos-amd64.tar.gz"
      @sha256_checksum = "259765d5ccdf24450b7d8a2ae35a47bce6d9dd60db03b132d64c1f9333e04e31"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      @archive_file = "observability-cli-linux-amd64.tar.gz"
      @sha256_checksum = "c66d11057bd9604796355ebcba6ddd6e2907cbb752950ab6df8df32f7184305e"
    elsif Hardware::CPU.arm?
      @archive_file = "observability-cli-linux-arm64.tar.gz"
      @sha256_checksum = "0eaa27d3c030b4c3167b179e27451e63a53e7337db63bdea853bb7e0ff9548ca"
    end
  end
  
  url "https://github.com/superbet-group/observability.application.observability-cli/releases/download/v#{version}/#{@archive_file}",
    using: GitHubPrivateRepositoryReleaseDownloadStrategy

  sha256 @sha256_checksum

  def install
    bin.install "observability-cli"
    chmod "+x", bin/"observability-cli"
  end
end
