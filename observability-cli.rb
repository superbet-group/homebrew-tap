require_relative "custom_download_strategy"
class ObservabilityCli < Formula
  desc "Application Observability CLI for Superbet Group"
  homepage "https://github.com/superbet-group/observability.application.observability-cli"
  version "1.4.0"

  on_macos do
    if Hardware::CPU.arm?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-macos-arm64.tar.gz"
      @sha256_checksum = "f08e3eb9ba0fe77b1dc9e69d6740de16f3f19f77977034ccdd8569c481298127"
    elsif Hardware::CPU.intel?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-macos-amd64.tar.gz"
      @sha256_checksum = "4d1d50ddf014d57bbadc711edd42b9119861b5759c871e63c9ee5bb919cf6927"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-linux-amd64.tar.gz"
      @sha256_checksum = "9e34ea7009fd38e4cda4d2d85da083d0c587131e68214b3256ec10c440551d7a"
    elsif Hardware::CPU.arm?
      @binary_name = "observability-cli"
      @archive_file = "observability-cli-linux-arm64.tar.gz"
      @sha256_checksum = "ea2a9c736f8d470218bd86b35d85224043da772d5e9911db60a5a054df13eb63"
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
