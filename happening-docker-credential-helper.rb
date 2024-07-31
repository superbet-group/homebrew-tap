require_relative "custom_download_strategy"
class HappeningDockerCredentialHelper < Formula
  desc "Docker credential helper for accessing ECR repos via teleport.happening.dev"
  homepage "https://github.com/superbet-group/sre.docker-credential-helper"
  version "0.0.5"

  depends_on "jq"
  
  url "https://github.com/superbet-group/sre.docker-credential-helper/releases/download/0.0.5/docker-credential-helper.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "b754c941c40854b8dc30da19c7fa46482528bcac5264c0b20623b308a289cffd"
  
  def install
    bin.install "docker-credential-teleport-happening-ecr"
  end

  def caveats
    <<~EOS
        For configuring docker daemon to use this credential helper for enabled repos, please run:

            \e[1;32m#{opt_prefix}/bin/docker-credential-teleport-happening-ecr configure\e[0m

    EOS
  end

end
