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
      sha256 "2fe4e4631ee40b9a8aa9fcfe7769d3a91c3a7b4a130c0623cba2b8a2949f0204"

      def install
        bin.install "ec2-instance-selector"
        chmod "+x", bin/"ec2-instance-selector"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/superbet-group/platform.ec2-instance-selector/releases/download/v3.1.2-superbet.1/ec2-instance-selector-darwin-arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "7dc31267360af449623c7a0326ac7238d1c06b3f9ce1240ea084e77676623c1d"

      def install
        bin.install "ec2-instance-selector"
        chmod "+x", bin/"ec2-instance-selector"
      end
    end
  end
end
