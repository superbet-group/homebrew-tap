require_relative "custom_download_strategy"
cask "betssm" do
  version "5"
  sha256 "b65a4d8a08a4a045bfae020e0205fb8167927dec999a3b9e4b00b5ed33c15a79"

  url "https://raw.githubusercontent.com/superbet-group/betler.infra.betssm/refs/tags/#{version}/betssm", using: GitHubPrivateRepositoryFileDownloadStrategy
  name "betssm"
  desc "Betler CLI Tool for Interacting with Infra"
  homepage "https://github.com/superbet-group/betler.infra.betssm"

  binary "#{staged_path}/betler.infra.betssm", target: "/usr/local/bin/betssm"
end
