# typed: false
# frozen_string_literal: true

require_relative "custom_download_strategy"
class Lola < Formula
  desc "Local infra starting and provisioning CLI."
  homepage "https://github.com/superbet-group/engprod.lola"
  version "0.0.32"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.32/lola-macos-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "525a70283d4832770d098880cb757c05549c9259a4f6865e547eb03fa4265b93"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion")
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.32/lola-macos-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "e3e0806b309c6d5480654984b4f0155218ca738185dd1acc25fbf5a762df0a7b"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion")
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.32/lola-ubuntu-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "b46168d46a93e9445038d472e1a0dfab0c064875165e3742cb37a63f20a0d668"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
        generate_completions_from_executable(bin/"lola", "--show-completion")
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.32/lola-alpine-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "86a6fc86d631d0b9b6ec334d2597b6b4b8a1dfa5fd76e830ae8b9e8ebb34a052"

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
