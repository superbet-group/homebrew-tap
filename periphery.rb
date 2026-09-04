# typed: false
# frozen_string_literal: true

class Periphery < Formula
  desc "Tool to identify unused code in Swift projects"
  homepage "https://github.com/superology-ios/periphery"
  version "3.7.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/superology-ios/periphery/releases/download/3.7.7/periphery-3.7.7-arm64.tar.gz"
      sha256 "5422a686fcbc7ca0e69add3e64960b333b9682823a0f4f49f6bab897345be9c1"

      define_method(:install) do
        bin.install "periphery"
      end
    end
  end

  test do
    system bin/"periphery", "version"
  end
end
