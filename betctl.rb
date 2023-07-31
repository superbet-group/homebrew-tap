# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "custom_download_strategy"
class Betctl < Formula
  desc ""
  homepage ""
  version "2.101.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v2.101.9/betting.test.framework_Darwin_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "a568a031e22bd685277f7cc677e7a1e335954542c659f4d5bec536ef6e8c94cb"

      def install
        bin.install "betctl"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v2.101.9/betting.test.framework_Darwin_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "f6d3136bb4cc304f17959cdf6ee09205d921a57c4341181729172178d35e20c0"

      def install
        bin.install "betctl"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v2.101.9/betting.test.framework_Linux_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "e5fcdc2d45db79881547a66eebbf4aa6eb2a7549fc304e4b404da6531a7fca77"

      def install
        bin.install "betctl"
        generate_completions_from_executable(bin/"betctl", "completion")
      end
    end
  end

  def post_install
    prefix.install "misc/betctl-p10k.zsh" => "betctl-p10k.zsh"
  end

  def caveats
    <<~EOS
      <<~EOS
      To activate powerlevel10k integration, add the following line to .zshrc:

        source #{opt_prefix}/betctl-p10k.zsh

      If you have already done this step, feel free to ignore this message.

      Good luck with your testing endeavours :D
      EOS
    EOS
  end
end
