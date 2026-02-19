# typed: false
# frozen_string_literal: true

# Homebrew Formula Template for bedrock-token-helper
#
# IMPORTANT: This is a TEMPLATE file maintained in the bedrock-token-gateway repository.
# The actual formula in superbet-group/homebrew-tap is automatically generated from this template during release.
#
# DO NOT edit the formula in homebrew-tap directly.
#
# To update the formula:
#   1. Edit this template in bedrock-token-gateway repository
#   2. Create PR and merge changes
#   3. Create release tag: git tag helper/vX.Y.Z && git push origin helper/vX.Y.Z
#   4. Release workflow automatically renders template and creates PR in homebrew-tap
#
# Placeholders (automatically substituted during release):
#   0.2.5    - Semantic version (e.g., 1.2.3)
#   https://github.com/superbet-group/platform.bedrock-token-gateway/releases/download/helper/v0.2.5/bedrock-token-helper-0.2.5.tar.gz  - GitHub release asset URL
#   172e9ce4b1b4a13b1bb7d533f6364f434ac6f52eeaaf9ba56860d98e710378cf     - Tarball SHA256 checksum

require_relative "custom_download_strategy"

class BedrockTokenHelper < Formula
  desc "Claude Code Bedrock token helper via Teleport"
  homepage "https://github.com/superbet-group/platform.bedrock-token-gateway"

  # Production URL (requires HOMEBREW_GITHUB_API_TOKEN)
  url "https://github.com/superbet-group/platform.bedrock-token-gateway/releases/download/helper/v0.2.5/bedrock-token-helper-0.2.5.tar.gz",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "172e9ce4b1b4a13b1bb7d533f6364f434ac6f52eeaaf9ba56860d98e710378cf"

  depends_on "jq"

  def install
    # Check for tsh before installing
    # Note: which() may not find tsh in /usr/local/bin, so we check multiple locations
    tsh_found = which("tsh") ||
                File.exist?("/usr/local/bin/tsh") ||
                File.exist?("/opt/homebrew/bin/tsh") ||
                File.exist?("/home/linuxbrew/.linuxbrew/bin/tsh") ||
                system("command -v tsh >/dev/null 2>&1")
    unless tsh_found
      install_command = if OS.mac?
        "brew install superbet-group/tap/teleport-cli"
      else
        "brew install superbet-group/tap/wsl-teleport-cli"
      end

      odie <<~EOS
        Teleport CLI (tsh) is required but not found!
        Install it first with:
          #{install_command}
        Then retry:
          brew install superbet-group/tap/bedrock-token-helper
      EOS
    end

    # Install scripts to libexec/bedrock-token-gateway/ (organized directory)
    (libexec/"bedrock-token-gateway").mkpath
    (libexec/"bedrock-token-gateway").install "bedrock-token-helper.sh" => "bedrock-token-helper"

    # Create symlink in bin/ for PATH access
    bin.install_symlink libexec/"bedrock-token-gateway/bedrock-token-helper"
  end

  def caveats
    <<~EOS
      ======================================================================
      SETUP REQUIRED
      ======================================================================

      Run the setup wizard (recommended):
        bedrock-token-helper --setup

      To update your existing model identifiers to company defaults:
        bedrock-token-helper --setup --force-update-models

        By default, --setup preserves your existing model configuration.
        Use --force-update-models to update all default models
        (Sonnet, Haiku, Opus) to the company-recommended versions.

      Or manually configure ~/.claude/settings.json:
        {
          "apiKeyHelper": "#{HOMEBREW_PREFIX}/bin/bedrock-token-helper",
          "env": {
            "CLAUDE_CODE_USE_BEDROCK": "1",
            "CLAUDE_CODE_SKIP_BEDROCK_AUTH": "1",
            "AWS_REGION": "eu-west-1"
          }
        }

        NOTE: If using manual setup, also remove these settings if present:
          - env.CLAUDE_CODE_API_KEY_HELPER_TTL_MS
          - awsCredentialExport

      Documentation: https://www.notion.so/superbet/Bedrock-Token-Gateway-2df032f852c5803796d9c1c116fac510
      ======================================================================
    EOS
  end

  test do
    system bin/"bedrock-token-helper", "--help"
  end
end
