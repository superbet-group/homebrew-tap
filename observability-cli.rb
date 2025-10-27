require_relative "custom_download_strategy"
class ObservabilityCli < Formula
  desc "Application Observability CLI for Superbet Group"
  homepage "https://github.com/superbet-group/observability.application.observability-cli"
  version "1.4.8"

  @archive_file = nil
  @sha256_checksum = nil
  on_macos do
    if Hardware::CPU.arm?
      @archive_file = "observability-cli-macos-arm64.tar.gz"
      @sha256_checksum = "e03bbf22edba768f5d14d8077d38a70110cd6cd6b132033871bdd7ce01ee3a43"
    elsif Hardware::CPU.intel?
      @archive_file = "observability-cli-macos-amd64.tar.gz"
      @sha256_checksum = "348b9fbd7e511ebd0f3e352c58d5f8620fa6fd1f110d37757e1bd9ac906ad4fc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      @archive_file = "observability-cli-linux-amd64.tar.gz"
      @sha256_checksum = "827a63ccabc7f8582fb0895e43444a7f3c90c8c94effe9e832b31870f712d58d"
    elsif Hardware::CPU.arm?
      @archive_file = "observability-cli-linux-arm64.tar.gz"
      @sha256_checksum = "6a4df7ffe9b0a310e09f48c4796243976d267a97a3698f9769badaf2efa15d35"
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
