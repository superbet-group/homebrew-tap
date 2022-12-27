# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Betctl < Formula
  desc ""
  homepage ""
  version "0.1.0"

  depends_on "go" => :optional

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v0.1.0/betting.test.framework_0.1.0_darwin_arm64.tar.gz"
      sha256 "1b65412a6dd9f522998ba7631adf61b6546ceefa1513d93727b2ea328adf00eb"

      def install
        bin.install "betctl"
        bash_completion.install "completions/betctl.bash" => "betctl"
        zsh_completion.install "completions/betctl.zsh" => "_betctl"
        fish_completion.install "completions/betctl.fish"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v0.1.0/betting.test.framework_0.1.0_darwin_amd64.tar.gz"
      sha256 "b241ad3e5ccdbf76fc53433ba4fa3bea1d395da0454067662c54ca5078bd3bba"

      def install
        bin.install "betctl"
        bash_completion.install "completions/betctl.bash" => "betctl"
        zsh_completion.install "completions/betctl.zsh" => "_betctl"
        fish_completion.install "completions/betctl.fish"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v0.1.0/betting.test.framework_0.1.0_linux_arm64.tar.gz"
      sha256 "5b0cb3045c55fe16e3414c1c03c30763d2db1e9756d76bbf1f4f9f13c02a21ea"

      def install
        bin.install "betctl"
        bash_completion.install "completions/betctl.bash" => "betctl"
        zsh_completion.install "completions/betctl.zsh" => "_betctl"
        fish_completion.install "completions/betctl.fish"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/superbet-group/betting.test.framework/releases/download/v0.1.0/betting.test.framework_0.1.0_linux_amd64.tar.gz"
      sha256 "cf8c2d62bcae2541f9ef51368db4e64d9c95a410ec7ee0db8bace1d4ca30e83d"

      def install
        bin.install "betctl"
        bash_completion.install "completions/betctl.bash" => "betctl"
        zsh_completion.install "completions/betctl.zsh" => "_betctl"
        fish_completion.install "completions/betctl.fish"
      end
    end
  end
end
