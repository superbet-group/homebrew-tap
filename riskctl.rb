# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Riskctl < Formula
  desc ""
  homepage ""
  version "1.8.2"
  depends_on :macos

  on_intel do
    url "https://github.com/superbet-group/risk.cli/releases/download/v1.8.2/riskctl_1.8.2_macos_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "51d52018e138a9f846a89b337cbcc4220d8abe7a8b4dcaa924046d5d211be7a6"

    def install
      bin.install "riskctl"
      generate_completions_from_executable(bin/"riskctl", "completion")
    end
  end
  on_arm do
    url "https://github.com/superbet-group/risk.cli/releases/download/v1.8.2/riskctl_1.8.2_macos_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b8fd8f304e288ecffe40af109fb99230356546fd65b68bbe83f49742fc9a3d19"

    def install
      bin.install "riskctl"
      generate_completions_from_executable(bin/"riskctl", "completion")
    end
  end

  test do
    system "#{bin}/riskctl --help"
  end
end