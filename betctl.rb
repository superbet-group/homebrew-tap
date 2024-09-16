# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Betctl < Formula
  desc ""
  homepage ""
  version "2.170.5"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.170.5/betctl_2.170.5_macos_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "fb512ef8b3e10257d9382ed97e7aadb003d896a725ac0d4a842bf5db65fcb18b"

      def install
        bin.install "betctl"
        prefix.install "betctl-p10k.zsh"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
    on_arm do
      url "https://github.com/superbet-group/betting.cli/releases/download/v2.170.5/betctl_2.170.5_macos_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "7f5f0f0f8676660839f29bd465b5f3986dba108026edba7c520fd47ecec10d42"

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
        url "https://github.com/superbet-group/betting.cli/releases/download/v2.170.5/betctl_2.170.5_linux_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
        sha256 "1235219ff4ebd2c20cbffd91f2d796b17a6dfed9248eb0651ca7621ac424f2ee"

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
