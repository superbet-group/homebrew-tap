# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Betctl < Formula
  desc ""
  homepage ""
  version "2.183.0-feat-test-adding-user-agent-to-clients-api-request.1"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.183.0-feat-test-adding-user-agent-to-clients-api-request.1/betctl_2.183.0-feat-test-adding-user-agent-to-clients-api-request.1_macos_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "84f9fb9d00f2425aca2d7398df1e747027f821eafb684dfe7a3ac030ad5a07be"

      def install
        bin.install "betctl"
        prefix.install "betctl-p10k.zsh"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
    on_arm do
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.183.0-feat-test-adding-user-agent-to-clients-api-request.1/betctl_2.183.0-feat-test-adding-user-agent-to-clients-api-request.1_macos_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "43cd63983a21ff33452bc171a8894797f7676b52f7312bd95aa389ea308d038c"

      def install
        bin.install "betctl"
        prefix.install "betctl-p10k.zsh"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/superbet-group/betting.cli/releases/download/v2.183.0-feat-test-adding-user-agent-to-clients-api-request.1/betctl_2.183.0-feat-test-adding-user-agent-to-clients-api-request.1_linux_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
        sha256 "1b286cd24ba26eadb25ae7dad70d8e7623c44074ab3d4d42007b7ae0f911428f"

        def install
          bin.install "betctl"
          prefix.install "betctl-p10k.zsh"
          generate_completions_from_executable(bin/"betctl", "completion")
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/superbet-group/betting.cli/releases/download/v2.183.0-feat-test-adding-user-agent-to-clients-api-request.1/betctl_2.183.0-feat-test-adding-user-agent-to-clients-api-request.1_linux_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
        sha256 "871c035ef3a71f55b5899efe2f2ca99fa1cb941e0235193e40fa5b4f5b767129"

        def install
          bin.install "betctl"
          prefix.install "betctl-p10k.zsh"
          generate_completions_from_executable(bin/"betctl", "completion")
        end
      end
    end
  end

  def caveats
    <<~EOS
      To activate powerlevel10k integration, add the following line to .zshrc:

        source #{opt_prefix}/betctl-p10k.zsh

      Good luck with your testing endeavours :)
    EOS
  end

  test do
    system "#{bin}/betctl --help"
  end
end
