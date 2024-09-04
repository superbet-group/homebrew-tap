# typed: false
# frozen_string_literal: true
require_relative "custom_download_strategy"
class Lola < Formula
  desc "Local infra starting and provisioning CLI."
  homepage "https://github.com/superbet-group/engprod.lola"
  version "0.0.37"
  on_macos do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.37/lola-macos-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "ae3063aace7e00b4cd29e341a03a7b530e0ebaf7b5d07b727d27209d30987399"
      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:zsh])
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.37/lola-macos-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "874e92b6e9aeded41f096543ddd359db512c2a9078f836964cca57a93704956a"
      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:zsh])
      end
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.37/lola-ubuntu-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "9c5c0f61541db586dda09188278fe65619a08039d3520059f837e447b9fe107b"
      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:bash])
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.37/lola-alpine-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "76e3951ec5e1fc41d43e15d3bf5ec00f4ae600a11f8643cd416d3f03f01b1649"
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
