require_relative "custom_download_strategy"
class ObservabilityCli < Formula
  desc "Application Observability CLI for Superbet Group"
  homepage "https://github.com/superbet-group/observability.application.observability-cli"
  version "1.5.18"

  @archive_file = nil
  @sha256_checksum = nil
  on_macos do
    if Hardware::CPU.arm?
      @archive_file = "observability-cli-macos-arm64.tar.gz"
      @sha256_checksum = "c71a1611403f4ef64f87c417cab8f3f306f390b7dc157cc0e323cd66f6802adb"
    elsif Hardware::CPU.intel?
      @archive_file = "observability-cli-macos-amd64.tar.gz"
      @sha256_checksum = "9368428e6f44342c2d3e65fe74c5c76288539089e174dc01c5796ba4a7c3aad6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      @archive_file = "observability-cli-linux-amd64.tar.gz"
      @sha256_checksum = "48f83f9a6fdbe2d8c17523fa985eaef69da0a848feef6f7c8b1f2e3e1c5fbc10"
    elsif Hardware::CPU.arm?
      @archive_file = "observability-cli-linux-arm64.tar.gz"
      @sha256_checksum = "f434c7484ca05be31ce57e9a76395ae57f9f38eb00c51b54b1b1e2f339531321"
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
