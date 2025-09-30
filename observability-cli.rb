require_relative "custom_download_strategy"
class ObservabilityCli < Formula
  desc "Application Observability CLI for Superbet Group"
  homepage "https://github.com/superbet-group/observability.application.observability-cli"
  version "1.4.3"

  on_macos do
    if Hardware::CPU.arm?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-macos-arm64.tar.gz"
      @sha256_checksum = "45579060b732efb14c5bf0dc70fc99e04306b6f635e8cd600c7b0e5649873929"
    elsif Hardware::CPU.intel?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-macos-amd64.tar.gz"
      @sha256_checksum = "7c4750f63d8982deac72e8fbd09dc6b24a0a3aae1c9aa5c463e271ce79fe1c26"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-linux-amd64.tar.gz"
      @sha256_checksum = "75cf8c09185f17968ecf01a0770dbaefb34288cd50c6c5720e83c6705620c780"
    elsif Hardware::CPU.arm?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-linux-arm64.tar.gz"
      @sha256_checksum = "704147efc1bf98d87653038ef713f703f7d51eb7362b0ecbf8fc9ba299f785e2"
    end
  end
  
  url "https://github.com/superbet-group/observability.application.observability-cli/releases/download/v#{version}/#{@archive_file}",
    using: GitHubPrivateRepositoryReleaseDownloadStrategy

  sha256 @sha256_checksum

  def install
    bin.install @binary_name => "observability-cli"
    chmod "+x", bin/"observability-cli"
  end

  test do
    system "#{bin}/observability-cli", "--help"
  end
end
