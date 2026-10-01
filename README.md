# Superbet Group Homebrew tap

## How to Setup
1. Run `brew tap superbet-group/tap`
2. Run `brew update`
3. Trust this tap (or the specific formula/cask you need) — see [Trusting this tap](#trusting-this-tap) below
4. Run `brew install` for whichever formula or cask you want to install from this tap

### Trusting this tap

Since this is a third-party (non-official) tap, newer versions of Homebrew require you to explicitly trust it before installing or upgrading, otherwise you'll see warnings like:

```
Warning: Calling HOMEBREW_NO_REQUIRE_TAP_TRUST is deprecated! Use `brew trust` for each non-official tap, formula, cask or command instead.
Warning: Calling the `verified` parameter in the `url` stanza is deprecated! Use the default URL verification behaviour instead.
```

The old `HOMEBREW_NO_REQUIRE_TAP_TRUST` environment variable is deprecated and will eventually be removed. Use `brew trust` instead, per [Homebrew's Tap Trust docs](https://docs.brew.sh/Tap-Trust):

- Trust the whole tap (accepts all current and future formulae/casks/commands from it):
  ```
  brew trust superbet-group/tap
  ```
- Or, trust only a specific formula:
  ```
  brew trust --formula superbet-group/tap/<formula-name>
  ```
- Or, trust only a specific cask:
  ```
  brew trust --cask superbet-group/tap/<cask-name>
  ```

Homebrew recommends trusting individual formulae/casks rather than the whole tap where possible. You can list what you've already trusted with `brew trust`, and revoke trust with `brew untrust superbet-group/tap` (or `brew untrust --formula superbet-group/tap/<formula-name>`).

### Prerequisites for Installing Private Formulae

Since most of the formulae are linked to private Github repos you will need to have a valid Github token exported under the name `HOMEBREW_GITHUB_API_TOKEN`. The token needs permissions to download assets from the Github Releases page. The easiest way to do this is to add `export HOMEBREW_GITHUB_API_TOKEN="my_gh_token"` to your `.zshrc` file. This can also be done using the Github CLI tool.

#### Steps:
1. Run `gh auth login` and follow the setup instructions (the recommended protocol to use is HTTPS). If you already did this at some point feel free to skip this step.
2. Run `gh auth token` to check that everything works. The output should contain a valid GitHub token.
3. Add `HOMEBREW_GITHUB_API_TOKEN` to your environment variables.
   1. Run `echo 'export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"' >> ~/.zshrc` to automatically add `HOMEBREW_GITHUB_API_TOKEN` to your environment variables.  
Alternatively, you can just add the line `export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"` yourself.
   2. Run `source ~/.zshrc` to refresh your environment variables.
