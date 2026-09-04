# typed: false
# frozen_string_literal: true

class Periphery < Formula
  desc "Tool to identify unused code in Swift projects"
  homepage "https://github.com/superology-ios/periphery"
  version "3.7.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/superology-ios/periphery/releases/download/3.7.8/periphery-3.7.8-arm64.tar.gz"
      sha256 "802ad6932f9a72f55a93200a7edd8e63ab3a0a7632b23426f3e4bd16a53bc4ed"

      define_method(:install) do
        bin.install "periphery"
      end
    end
  end

  test do
    system bin/"periphery", "version"
  end
end
