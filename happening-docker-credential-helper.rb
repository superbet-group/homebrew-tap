require_relative "custom_download_strategy"
class HappeningDockerCredentialHelper < Formula
  desc "Docker credential helper for accessing ECR repos via teleport.happening.dev"
  homepage "https://github.com/superbet-group/sre.docker-credential-helper"
  version "0.0.3"

  depends_on "jq"
  
  url "https://github.com/superbet-group/sre.docker-credential-helper/releases/download/0.0.3/docker-credential-helper.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "6ee0a787bcd46e73c9eebabeee1b68b40440010297641ded6a644ffa7f2cfc48"
  
  def install
    bin.install "docker-credential-teleport-happening-ecr"
    system "./configure.sh"
  end

end
