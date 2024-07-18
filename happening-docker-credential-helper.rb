require_relative "custom_download_strategy"
class HappeningDockerCredHelper < Formula
  desc "Docker credential helper for accessing ECR repos via teleport.happening.dev"
  homepage ""
  version "0.0.1"

  depends_on "jq"
  
  url "https://github.com/superbet-group/engprod.lola/releases/download/v0.0.29/lola-macos-amd64.bundle.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "d0c372dbd7d3ebee7a8ed3a358a4d93ea416ea226907fe07cc97fd64af1bf393"
  
  def install
    bin.install "docker-credential-teleport-happening-ecr"
    system "./configure.sh"
  end

end
