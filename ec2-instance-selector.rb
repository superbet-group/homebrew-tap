# typed: false
# frozen_string_literal: true

require_relative "custom_download_strategy"
class Ec2InstanceSelector < Formula
  desc "EC2 Instance Selector - A CLI tool to help you find the right EC2 instance type"
  homepage "https://github.com/superbet-group/platform.ec2-instance-selector"
  version "3.1.2-test.13"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/platform.ec2-instance-selector/releases/download/v3.1.2-test.13/ec2-instance-selector-darwin-amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "e7545b55e62c87914d8cb1f3284db66bbf94df9bcf94e32febaac0ecd3cef77a"

      def install
        bin.install "ec2-instance-selector"
        chmod "+x", bin/"ec2-instance-selector"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/superbet-group/platform.ec2-instance-selector/releases/download/v3.1.2-test.13/ec2-instance-selector-darwin-arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "9869a22316f12e6d17030992714ea6da163ab99930bbfa405a77f75adf1ff44d"

      def install
        bin.install "ec2-instance-selector"
        chmod "+x", bin/"ec2-instance-selector"
      end
    end
  end
end
