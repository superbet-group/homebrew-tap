# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Riskctl < Formula
  desc ""
  homepage ""
  version "1.8.3"
  depends_on :macos

  on_intel do
    url "https://github.com/superbet-group/risk.cli/releases/download/v1.8.3/riskctl_1.8.3_macos_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "e394e9824e9b6677d24eb59613227c5850ff18c9a8a692a9cd22d9ff62de4910"

    def install
      bin.install "riskctl"
      generate_completions_from_executable(bin/"riskctl", "completion")
    end
  end
  on_arm do
    url "https://github.com/superbet-group/risk.cli/releases/download/v1.8.3/riskctl_1.8.3_macos_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "337de4531193c44e6eb9a546de937ae212f97c2627d09a8db9d19811057c3f98"

    def install
      bin.install "riskctl"
      generate_completions_from_executable(bin/"riskctl", "completion")
    end
  end

  test do
    system "#{bin}/riskctl --help"
  end
end
