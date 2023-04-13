class GithubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
    require "utils/formatter"
    require "utils/github"

    # These arguments are all bound to instance variables by the super's initialize.
    def initialize(url, name, version, **meta)
      super
      parse_url_pattern
      set_github_token
    end

    def fetch(*)
      download_lock = LockFile.new(temporary_path.basename)
      download_lock.lock

      begin
        download_file!
        ignore_interrupts do
          cached_location.dirname.mkpath
          temporary_path.rename(cached_location)
          symlink_location.dirname.mkpath
        end

        FileUtils.ln_s cached_location.relative_path_from(symlink_location.dirname), symlink_location, force: true
      rescue ErrorDuringExecution
        raise CurlDownloadStrategyError, url
      rescue Timeout::Error => e
        raise Timeout::Error, "Timed out downloading #{self.url}: #{e}"
      end
    ensure
      download_lock&.unlock
      download_lock&.path&.unlink
    end

    private

    def download_file!
      # HTTP request header `Accept: application/octet-stream` is required.
      # Without this, the GitHub API will respond with metadata, not binary.
      url = "https://api.github.com/repos/#{@owner}/#{@repo}/" \
        "releases/assets/#{asset_id}"
      ohai "Downloading #{url}"
      curl_download url,
        "--header", "Authorization: Bearer #{@github_token}",
        "--header", "Accept: application/octet-stream",
        to: temporary_path
    end

    def parse_url_pattern
      url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
      unless @url&.match?(url_pattern)
        raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
      end

      _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
    end

    def set_github_token
      @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
      unless @github_token
        raise CurlDownloadStrategyError,
          "Environment variable HOMEBREW_GITHUB_API_TOKEN is required."
      end

      validate_github_repository_access!
    end

    def validate_github_repository_access!
      # Test access to the repository
      GitHub.repository(@owner, @repo)
    rescue GitHub::API::HTTPNotFoundError
      # We only handle HTTPNotFoundError here,
      # because AuthenticationFailedError is handled within util/github.
      message =
        "HOMEBREW_GITHUB_API_TOKEN can not access the repository: #{@owner}/#{@repo}" \
        "This token may not have permission to access the repository or the url of" \
        "the formula may be incorrect."
      raise CurlDownloadStrategyError, message
    end

    def asset_id
      release_metadata = fetch_release_metadata
      asset = release_metadata["assets"].find { |a| a["name"] == @filename }
      raise CurlDownloadStrategyError, "Asset file not found." if asset.nil?

      asset["id"]
    end

    def fetch_release_metadata
      release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/" \
        "releases/tags/#{@tag}"
      GitHub::API.open_rest(release_url)
    end
  end
