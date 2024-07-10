# typed: false
# frozen_string_literal: true

require_relative "custom_download_strategy"
class Lola < Formula
  desc "Local infra starting and provisioning CLI."
  homepage "https://github.com/superbet-group/engprod.lola"
  version "0.0.29"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.29/lola-macos-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "d0c372dbd7d3ebee7a8ed3a358a4d93ea416ea226907fe07cc97fd64af1bf393"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.29/lola-macos-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "d4855e1f2a78f3452a33b6af132245eb8d733570d8f74c4484ed0592df2730e3"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.29/lola-ubuntu-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "feb737713377873900f4a1c30114b41c1f235a4b33c10be5f0b46e4eafe346d6"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
      end
    end
    on_arm do
      url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.29/lola-alpine-arm64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "107fcb5b4a783a0fa16663ffded37d428dca44204bf3096f918348aadb5a2bd9"

      def install
        bin.install "lola/_internal/"
        bin.install "lola/lola"
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
