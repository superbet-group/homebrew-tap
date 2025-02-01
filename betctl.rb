# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Betctl < Formula
  desc ""
  homepage ""
  version "2.196.3"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.196.3/betctl_2.196.3_macos_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "348fc917cea12f41232ea426c02292b8e15950cde9f4f368e64ae433a3180fcb"

      def install
        bin.install "betctl"
        prefix.install "betctl-p10k.zsh"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.196.3/betctl_2.196.3_macos_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "bf0b4dc2c4f543b38958bc308d61e7c847762b010c077784ec07684f05415afa"

      def install
        bin.install "betctl"
        prefix.install "betctl-p10k.zsh"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/superbet-group/betting.cli/releases/download/v2.196.3/betctl_2.196.3_linux_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
        sha256 "6ec29c9bf0b7d425210b2a16756fbf68b8b711731ff562e97e1be92de5c9c36d"

        def install
          bin.install "betctl"
          prefix.install "betctl-p10k.zsh"
          generate_completions_from_executable(bin/"betctl", "completion")
        end
      end
    end
    if Hardware::CPU.arm?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/superbet-group/betting.cli/releases/download/v2.196.3/betctl_2.196.3_linux_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
        sha256 "5753ae4c3af75a1fc12ea07f46a736e9d51a4d60d4884d39f906cf37207d1ae0"

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
