# typed: false
# frozen_string_literal: true

require_relative "custom_download_strategy"
class Ec2InstanceSelector < Formula
  desc "EC2 Instance Selector - A CLI tool to help you find the right EC2 instance type"
  homepage "https://github.com/superbet-group/platform.ec2-instance-selector"
  version "3.1.2-superbet.1"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/platform.ec2-instance-selector/releases/download/v3.1.2-superbet.1/ec2-instance-selector-darwin-amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "f22a20634e899bd5a7485a9c3d66c9c74a9fb7366cd604ed2fac0c560bf0a1ca"

      def install
        bin.install "ec2-instance-selector"
        chmod "+x", bin/"ec2-instance-selector"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/superbet-group/platform.ec2-instance-selector/releases/download/v3.1.2-superbet.1/ec2-instance-selector-darwin-arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "80bf61e0df16a2877f228d2148a735cf3700b812cec534637cfb65d0c45b03d8"

      def install
        bin.install "ec2-instance-selector"
        chmod "+x", bin/"ec2-instance-selector"
      end
    end
  end
end
