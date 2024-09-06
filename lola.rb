# typed: false
# frozen_string_literal: true

require_relative "custom_download_strategy"
class Lola < Formula
  desc "Local infra starting and provisioning CLI."
  homepage "https://github.com/superbet-group/engprod.lola"
  version "0.0.39"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.39/lola-macos-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "8aa0ea4e2d3adc53c64dd03bae4727ba92a071fa929d07797fa26d1d271e25c1"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:zsh])
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.39/lola-macos-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "53b40e1057539a71e43ced17f4f549b1cac3c4714b5c39f2bc79381b80dc0561"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:zsh])
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.39/lola-ubuntu-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "f4ca00aa38eccd60c64ec4ebe4cbf033c7ca51becc24b482429ba855145678a5"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion", shells: [:bash])
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.39/lola-alpine-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "cb0d6d89aafff5595344af685ae51e69c86da54678d400697122f3fdb7015c9c"

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
