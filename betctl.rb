# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Betctl < Formula
  desc ""
  homepage ""
  version "2.173.9"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.173.9/betctl_2.173.9_macos_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "409bb63b65e099027020b303d3bf2075279a54d0bf829ed3f3793c30d4c01605"

      def install
        bin.install "betctl"
        prefix.install "betctl-p10k.zsh"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
    on_arm do
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.173.9/betctl_2.173.9_macos_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "35ec74a0159c19402ab1d4ca098ecaa6afb6e322633e8217953608177a0e3384"

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
        url "https://github.com/superbet-group/betting.cli/releases/download/v2.173.9/betctl_2.173.9_linux_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
        sha256 "aa57e771f50004fa95bb14dd681f29034dccf173a4cca87cec5a09848b0eb33e"

        def install
          bin.install "betctl"
          prefix.install "betctl-p10k.zsh"
          generate_completions_from_executable(bin/"betctl", "completion")
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/superbet-group/betting.cli/releases/download/v2.173.9/betctl_2.173.9_linux_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
        sha256 "cde82f75366f33a6a6c79e3db9ae8cf8a3526cec871c3bd681f17132ba4bb766"

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
