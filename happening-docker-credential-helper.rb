require_relative "custom_download_strategy"
class HappeningDockerCredHelper < Formula
  desc "Docker credential helper for accessing ECR repos via teleport.happening.dev"
  homepage "https://github.com/superbet-group/sre.docker-credential-helper"
  version "0.0.1"

  depends_on "jq"
  
  url "https://github.com/superbet-group/sre.docker-credential-helper/archive/refs/tags/0.0.1.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "42715fa310854a7db574b11be133bab028bbbeee0c7edcd52cef2ed18304832c"
  
  def install
    bin.install "docker-credential-teleport-happening-ecr"
    system "./configure.sh"
  end

end
