# typed: false
# frozen_string_literal: true

require_relative "custom_download_strategy"
class Lola < Formula
  desc "Local infra starting and provisioning CLI."
  homepage "https://github.com/superbet-group/engprod.lola"
  version "0.0.34"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.34/lola-macos-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "b5a1b4caa755764f9bf6bcd6be532ac96fbabf84bae2320cfbee55baa3005dde"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion")
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.34/lola-macos-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "a8ed4dfedc56c147a487828458b27c7e6bf8021bbb4f51f7e6b05beecf94ac3f"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion")
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.34/lola-ubuntu-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "b8928d84e4135bccae558c56cbac52d68fa53ad044b4e6854d956c493f9b8cd3"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion")
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.34/lola-alpine-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "c3837eb6559da3790721bb9dd4c45537f82191579767113e62360db587ca2e6c"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion")
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
