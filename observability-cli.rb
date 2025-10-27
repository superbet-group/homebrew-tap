require_relative "custom_download_strategy"
class ObservabilityCli < Formula
  desc "Application Observability CLI for Superbet Group"
  homepage "https://github.com/superbet-group/observability.application.observability-cli"
  version "1.4.7"

  @archive_file = nil
  @sha256_checksum = nil
  on_macos do
    if Hardware::CPU.arm?
      @archive_file = "observability-cli-macos-arm64.tar.gz"
      @sha256_checksum = "719a9b098ae3e56b987022e17dce02c021d522504cf3db72bcd0e9153272a876"
    elsif Hardware::CPU.intel?
      @archive_file = "observability-cli-macos-amd64.tar.gz"
      @sha256_checksum = "e0c423e3dbb463d7a3a69574e9b74cd6a82acadca7ae169aba9c009c34fe4433"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      @archive_file = "observability-cli-linux-amd64.tar.gz"
      @sha256_checksum = "e9e234a2cea9ac1553e458db2ae614d4144b88d42f29b3569699d0a8e7df8ae9"
    elsif Hardware::CPU.arm?
      @archive_file = "observability-cli-linux-arm64.tar.gz"
      @sha256_checksum = "e289d9baa4c007304b12fd50f9c7f31c185132a4627d66e40e3cd2458afe649e"
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
