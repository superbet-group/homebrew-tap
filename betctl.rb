# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Betctl < Formula
  desc ""
  homepage ""
  version "2.99.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v2.99.9/betting.test.framework_2.99.9_darwin_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "d76471d9a5440c5f20a4752eac9245f46d9452d9ecc650cd752e708b0fbbd3cf"

      def install
        bin.install "betctl"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v2.99.9/betting.test.framework_2.99.9_darwin_amd64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "b85e907080a69f7a1305113eafed0f5d3b5ec2eeca317fa70fc0438323259cfe"

      def install
        bin.install "betctl"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v2.99.9/betting.test.framework_2.99.9_linux_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "7d97c1446ba9afad1fa965b480b4e0ae2bd7238f48df1dc298a9029bd2b9101b"

      def install
        bin.install "betctl"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v2.99.9/betting.test.framework_2.99.9_linux_amd64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "c0ca461cf6539d408ba18aacea11aefd4b49a25c72994372972cfdb7c750a1a8"

      def install
        bin.install "betctl"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
  end
end
