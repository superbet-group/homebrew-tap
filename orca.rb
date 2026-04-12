# typed: false
# frozen_string_literal: true

require_relative "custom_download_strategy"

class Orca < Formula
  desc "Orca - Offer platform CLI tool"
  homepage "https://github.com/superbet-group/offer.orca"
  license "MIT"
  version "1.0.1"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.1/orca_1.0.1_darwin_amd64.zip",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "e55797ff276666e20604234e2d91368e206e2d011b8b0b7709908a53fd5afb82"
    end
    on_arm do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.1/orca_1.0.1_darwin_arm64.zip",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "ef740378f2bba275c6206c515e5cc047b612696163b8806a70dac24652a0c59a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.1/orca_1.0.1_linux_amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "55a5a9b48f0d773fa616a26f0bcd2d433068cd6c6cd96601ad1914e2dc77a9a5"
    end
    on_arm do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.1/orca_1.0.1_linux_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "83f70966c0952380be8d788703fe8749a5cfd56566049c556a8d973466792a4b"
    end
  end

  def install
    bin.install "orca"
  end
end
