#!/bin/bash
# cleanup_teleport_cask.sh
#
# Removes the teleport-cli Homebrew cask and all its leftover artifacts
# before installing the universal teleport-cli formula.
# Safe to run multiple times (idempotent).
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/superbet-group/homebrew-tap/master/Casks/cleanup_teleport_cask.sh)
#
# Or locally:
#   chmod +x cleanup_teleport_cask.sh && ./cleanup_teleport_cask.sh

# shellcheck disable=SC2310  # -e intentionally omitted; errors handled per-command
set -uo pipefail

# macOS only — this script removes macOS Cask artifacts (pkgutil records, .app bundles)
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only. On Linux/WSL, simply run:"
  echo ""
  echo "    brew install superbet-group/tap/teleport-cli"
  exit 0
fi

WARNINGS=0

_ok()   { echo "    [ok]   $*"; }
_skip() { echo "    [skip] $*"; }
_warn() { echo "    [warn] $*" >&2; WARNINGS=$((WARNINGS + 1)); }

_summary() {
  echo ""
  if [ "$WARNINGS" -gt 0 ]; then
    echo "==> Cleanup finished with $WARNINGS warning(s) — review output above."
    echo "    Resolve any remaining issues before installing the formula."
  else
    echo "==> Cleanup complete. You can now install the formula:"
    echo ""
    echo "    brew install superbet-group/tap/teleport-cli"
  fi
  echo ""
}
trap _summary EXIT

# ── Homebrew ──────────────────────────────────────────────────────────────────

BREW=$(command -v brew 2>/dev/null || true)

if [ -z "$BREW" ]; then
  echo "Error: Homebrew not found in PATH." >&2
  exit 1
fi

# ── Uninstall cask ────────────────────────────────────────────────────────────

echo "==> Checking teleport-cli cask..."

if "$BREW" list --cask superbet-group/tap/teleport-cli &>/dev/null; then
  echo "==> Uninstalling teleport-cli cask..."
  if "$BREW" uninstall --cask superbet-group/tap/teleport-cli; then
    _ok "cask uninstalled"
  else
    _warn "brew uninstall failed — continuing with manual cleanup"
  fi
else
  _skip "teleport-cli cask not tracked by Homebrew"
fi

# ── Remove .app bundles ───────────────────────────────────────────────────────

echo "==> Removing .app bundles from /Applications..."

for app in tsh.app tctl.app; do
  path="/Applications/$app"
  if [ -d "$path" ]; then
    if sudo rm -rf "$path"; then
      _ok "removed $path"
    else
      _warn "failed to remove $path — try manually: sudo rm -rf $path"
    fi
  else
    _skip "$path not present"
  fi
done

# ── Remove symlinks / binaries from /usr/local/bin ───────────────────────────

echo "==> Checking /usr/local/bin for leftover teleport binaries..."

for binary in tsh tctl; do
  path="/usr/local/bin/$binary"
  if [ -L "$path" ]; then
    if sudo rm -f "$path"; then
      _ok "removed symlink $path"
    else
      _warn "failed to remove symlink $path — try manually: sudo rm -f $path"
    fi
  elif [ -f "$path" ]; then
    if sudo rm -f "$path"; then
      _ok "removed file $path"
    else
      _warn "failed to remove file $path — try manually: sudo rm -f $path"
    fi
  else
    _skip "$path not present"
  fi
done

# ── Forget pkgutil records ────────────────────────────────────────────────────

echo "==> Cleaning up pkgutil records..."

for pkg in \
  "com.gravitational.teleport" \
  "QH8AA5B8UP.com.gravitational.teleport.tsh" \
  "QH8AA5B8UP.com.gravitational.teleport.tctl"; do
  if sudo pkgutil --pkg-info "$pkg" &>/dev/null; then
    if sudo pkgutil --forget "$pkg"; then
      _ok "forgot $pkg"
    else
      _warn "failed to forget $pkg — try manually: sudo pkgutil --forget $pkg"
    fi
  else
    _skip "$pkg not registered"
  fi
done
