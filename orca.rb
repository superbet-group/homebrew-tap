# typed: false
# frozen_string_literal: true

class Orca < Formula
  desc "Orca - Sports platform CLI tool"
  homepage "https://github.com/superbet-group/offer.orca"
  license "MIT"
  version "1.0.0"

  on_macos do
    on_intel do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.0/orca_1.0.0_darwin_amd64.zip"
      sha256 "b595ebea0895b8209983eb8fddf6e1a178afca4b34ad6ea4b2c050fb79e5ac25"
    end
    on_arm do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.0/orca_1.0.0_darwin_arm64.zip"
      sha256 "d5e1292f5419a356d4fb7151a9a33db3ed4898a42ae2740e438770f4e167e4a7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.0/orca_1.0.0_linux_amd64.tar.gz"
      sha256 "8be80dd9d9af38e51ccf347ce1cc7cae4f72e8f62b553f297503f7bc28189517"
    end
    on_arm do
      url "https://github.com/superbet-group/offer.orca/releases/download/v1.0.0/orca_1.0.0_linux_arm64.tar.gz"
      sha256 "4fdb040a1ce6efa3fa38319284757e9519b112f5e5a89f1b48f512033ba4a799"
    end
  end

  def install
    bin.install "orca"
  end
end
