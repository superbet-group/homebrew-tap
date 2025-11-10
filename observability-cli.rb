require_relative "custom_download_strategy"
class ObservabilityCli < Formula
  desc "Application Observability CLI for Superbet Group"
  homepage "https://github.com/superbet-group/observability.application.observability-cli"
  version "1.5.9"

  @archive_file = nil
  @sha256_checksum = nil
  on_macos do
    if Hardware::CPU.arm?
      @archive_file = "observability-cli-macos-arm64.tar.gz"
      @sha256_checksum = "831d5066840e27de5add820f340a5ade2a0ad5f76bdc0a67732bf7d798e7cf7f"
    elsif Hardware::CPU.intel?
      @archive_file = "observability-cli-macos-amd64.tar.gz"
      @sha256_checksum = "9e7d545baf093b6793f617a297d01ec07ca12999b599f1b9650a281bd9e60a17"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      @archive_file = "observability-cli-linux-amd64.tar.gz"
      @sha256_checksum = "8d8a20a11e7a3b4659a4327a0334fa3a86c7b7213d46bde742db69150060ed0b"
    elsif Hardware::CPU.arm?
      @archive_file = "observability-cli-linux-arm64.tar.gz"
      @sha256_checksum = "3ef94b10a672456a65ab80c5882303ce77a6e812e7d580c4993be191aaa19cc5"
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
