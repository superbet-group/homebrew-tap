# frozen_string_literal: true

require "net/http"
require "uri"
require "utils/formatter"
require "utils/github"
require "open3"

# GitHubPrivateRepositoryDownloadStrategy downloads contents from GitHub
# Private Repository. To use it, add
# `:using => GitHubPrivateRepositoryDownloadStrategy` to the URL section of
# your formula.
#
# Authentication:
# This strategy uses GitHub access tokens from either:
# 1. HOMEBREW_GITHUB_API_TOKEN environment variable (recommended for CI/CD)
# 2. GitHub CLI (gh auth token) as fallback if env var is not set
#
# To set up:
# - Option 1 (env var): export HOMEBREW_GITHUB_API_TOKEN="ghp_..."
# - Option 2 (gh CLI): brew install gh && gh auth login
#
# This strategy is suitable for corporate use just like S3DownloadStrategy,
# because it lets you use a private GitHub repository for internal distribution.
# It works with public one, but in that case simply use CurlDownloadStrategy.
class GitHubPrivateRepositoryDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    # Expected URL format: https://github.com/OWNER/REPO/FILEPATH
    # Example: https://github.com/superbet-group/my-repo/raw/main/file.tar.gz
    # See: https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives
    url_pattern = %r{https://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+)/(?<filepath>\S+)}
    match = url.match(url_pattern)

    unless match
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Repository."
    end

    @owner = match[:owner]
    @repo = match[:repo]
    @filepath = match[:filepath]
  end

  def download_url
    "https://github.com/#{@owner}/#{@repo}/#{@filepath}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    curl_download download_url,
      "--header", "Authorization: token #{@github_token}",
      to: temporary_path
  end

  def set_github_token
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.strip

    # If env var is empty or not set, try GitHub CLI
    if @github_token.empty?
      @github_token = fetch_token_from_gh_cli
    end

    if @github_token.empty?
      message = <<~EOS
        GitHub token not found. To fix this:

        1. Install GitHub CLI:     brew install gh
        2. Authenticate:           gh auth login

        Or set token manually:
           export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)
      EOS
      raise CurlDownloadStrategyError, message
    end

    validate_github_repository_access!
  end

  def fetch_token_from_gh_cli
    # Homebrew may run with restricted PATH, so we try common installation paths
    gh_paths = [
      "/opt/homebrew/bin/gh",  # macOS Apple Silicon (Homebrew default)
      "/usr/local/bin/gh",     # macOS Intel / Linux manual install
      "/usr/bin/gh",           # Linux package manager (apt, dnf, yum)
      "gh"                     # Fallback to PATH lookup
    ]

    gh_paths.each do |gh_path|
      begin
        stdout, _, status = Open3.capture3(gh_path, "auth", "token")
        return stdout.strip if status.success? && !stdout.strip.empty?
      rescue Errno::ENOENT
        next
      end
    end

    ""
  end

  def validate_github_repository_access!
    # Use our token directly instead of Homebrew's GitHub module
    # which may not see tokens obtained from gh CLI
    uri = URI("https://api.github.com/repos/#{@owner}/#{@repo}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "token #{@github_token}"
    request["Accept"] = "application/vnd.github.v3+json"
    request["User-Agent"] = "Homebrew"

    response = http.request(request)

    case response.code.to_i
    when 200
      # Success - repository accessible
      return
    when 401
      message = <<~EOS
        GitHub authentication failed.
        Your token may be invalid or expired. Try: gh auth login
      EOS
      raise CurlDownloadStrategyError, message
    when 404
      message = <<~EOS
        Repository not found or inaccessible: #{@owner}/#{@repo}
        Token may not have permission or URL may be incorrect.
      EOS
      raise CurlDownloadStrategyError, message
    else
      message = <<~EOS
        Failed to access repository: #{@owner}/#{@repo}
        HTTP #{response.code}: #{response.message}
      EOS
      raise CurlDownloadStrategyError, message
    end
  rescue StandardError => e
    message = <<~EOS
      Failed to access repository: #{@owner}/#{@repo}
      Error: #{e.message}
    EOS
    raise CurlDownloadStrategyError, message
  end
end

# GitHubPrivateRepositoryReleaseDownloadStrategy downloads tarballs from GitHub
# Release assets. To use it, add
# `:using => GitHubPrivateRepositoryReleaseDownloadStrategy` to the URL section of
# your formula.
#
# This strategy uses the GitHub Releases API to download assets.
# See: https://docs.github.com/en/rest/releases/assets
class GitHubPrivateRepositoryReleaseDownloadStrategy < GitHubPrivateRepositoryDownloadStrategy
  def initialize(url, name, version, **meta)
    super
  end

  def resolve_url_basename_time_file_size(url, timeout: nil)
    [download_url, "", Time.now, 0, false]
  end

  def parse_url_pattern
    # Expected URL format: https://github.com/OWNER/REPO/releases/download/TAG/FILENAME
    # Example: https://github.com/superbet-group/my-repo/releases/download/v1.0.0/app-1.0.0.tar.gz
    # Note: TAG can contain slashes (e.g., helper/v1.0.0)
    # See: https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases
    url_pattern = %r{https://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+)/releases/download/(?<tag>.+)/(?<filename>[^/]+)$}
    match = @url.match(url_pattern)

    unless match
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end

    @owner = match[:owner]
    @repo = match[:repo]
    @tag = match[:tag]
    @filename = match[:filename]
  end

  def download_url
    # Uses GitHub Releases API to download asset by ID
    # See: https://docs.github.com/en/rest/releases/assets#get-a-release-asset
    "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    # HTTP request header `Accept: application/octet-stream` is required.
    # Without this, the GitHub API will respond with metadata, not binary.
    # See: https://docs.github.com/en/rest/releases/assets#get-a-release-asset
    curl_download download_url,
      "--header", "Authorization: token #{@github_token}",
      "--header", "Accept: application/octet-stream",
      to: temporary_path
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found." if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    # Use our token directly instead of Homebrew's GitHub module
    uri = URI("https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "token #{@github_token}"
    request["Accept"] = "application/vnd.github.v3+json"
    request["User-Agent"] = "Homebrew"

    response = http.request(request)

    case response.code.to_i
    when 200
      require "json"
      JSON.parse(response.body)
    when 404
      raise CurlDownloadStrategyError, "Release not found: #{@tag}"
    else
      raise CurlDownloadStrategyError, "Failed to fetch release: HTTP #{response.code}"
    end
  end
end
