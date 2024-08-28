# Superbet Group Homebrew tap

## How to Setup
1. Run `brew tap superbet-group/tap`
2. Run `brew update`
3. Run `brew install` for whichever formula or cask you want to install from this tap

### Prerequisites for Installing Private Formulae

Since most of the formulae are linked to private Github repos you will need to have a valid Github token exported under the name `HOMEBREW_GITHUB_API_TOKEN`. The token needs permissions to download assets from the Github Releases page. The easiest way to do this is to add `export HOMEBREW_GITHUB_API_TOKEN="my_gh_token"` to your `.zshrc` file. This can also be done using the Github CLI tool.

#### Steps:
1. Run `gh auth login` and follow the setup instructions (the recommended protocol to use is HTTPS). If you already did this at some point feel free to skip this step.
2. Run `gh auth token` to check that everything works. The output should contain a valid GitHub token.
3. Add `HOMEBREW_GITHUB_API_TOKEN` to your environment variables.
   1. Run `echo 'export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"' >> ~/.zshrc` to automatically add `HOMEBREW_GITHUB_API_TOKEN` to your environment variables.  
Alternatively, you can just add the line `export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"` yourself.
   2. Run `source ~/.zshrc` to refresh your environment variables.
