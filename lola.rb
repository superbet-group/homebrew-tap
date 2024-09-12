# typed: false
# frozen_string_literal: true
require_relative "custom_download_strategy"
class Lola < Formula
  desc "Local infra starting and provisioning CLI."
  homepage "https://github.com/superbet-group/engprod.lola"
  version "0.0.41"
  on_macos do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.41/lola-macos-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "3a60462095922ddef7728e8670e1d83ae7300b592ae7f4941543dd77dc4cf7f4"
      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:zsh])
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.41/lola-macos-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "cf2579a4f6232cd63f60f8e1c90771dd3195352a2528e451a4e285dcb01b306d"
      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:zsh])
      end
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.41/lola-ubuntu-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "9e920d30aea5c7b798b71af540dc281e77f622ef4f1ca99183480d87214aa556"
      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:bash])
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.41/lola-alpine-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "28dbc7ba24208cd219ea5c01dde24ff1b230fc69f023af2d010df51f0a75937e"
      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:bash])
      end
    end
  end
  def caveats
    <<~EOS
    Requirements:
      * AMD64 Linux with GLIBC >= 2.29 (Ubuntu 20.04+) Mac or ARM Mac
      * `docker`
      * `docker-compose`
        * * `docker-compose` -> https://github.com/docker/compose/releases
      * `aws-cli` (for provisioning dynamodb tables)
      * `engprod.local-development` cloned and path added to environment variable `LOCAL_DEV_PATH`
        * https://github.com/superbet-group/engprod.local-development
        ```
        git clone git@github.com:superbet-group/engprod.local-development.git
        export LOCAL_DEV_PATH=/my/path/engprod.local-development # or add it to your .zshrc or .bashrc
        ```
    EOS
  end
  test do
    system "#{bin}/lola --help"
  end
end
