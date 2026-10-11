cask "teleport-cli" do
  version "18.10.4"
  # To get updated sha256:
  # VERSION=18.10.4; curl -fsSL "https://cdn.teleport.dev/teleport-ent-${VERSION}.pkg.sha256"
  sha256 "826bcdb9ab4c8d0627e8bb5849008fed00d2589e6fd3d737952d361ea127f0c6"

  url "https://cdn.teleport.dev/teleport-ent-#{version}.pkg"
  name "Teleport enterprise utilities"
  desc "Access proxy for k8s, aws, apps, dbs and servers via ssh/rdp"
  homepage "https://goteleport.com/"

  livecheck do
    url "https://goteleport.com/download/"
    regex(/teleport-ent[._-]v?(\d+(?:\.\d+)+)\.pkg/i)
  end

  # Multiple teleport packages install the same binaries (tsh, tctl) into
  # /usr/local/bin/, leaving broken symlinks when one of them is uninstalled.
  # Homebrew refuses to install this cask while any of these casks is present.
  conflicts_with cask: [
    "teleport-connect",
    "teleport-suite",
    "teleport-suite@16",
    "teleport-suite@17",
    "tsh",
  ]

  pkg "teleport-ent-#{version}.pkg"

  # `conflicts_with` cannot reference formulae, so the `teleport` formula is
  # checked here. The steps DSL only allows literal step calls, hence /bin/sh.
  preflight_steps do
    run "/bin/sh", args: [
      "-c",
      "if [ -d \"{{HOMEBREW_CELLAR}}/teleport\" ]; then " \
      "printf '\\033[1;31mConflicting package detected:\\033[0m teleport (formula)\\n\\n" \
      "\\033[1;33mTo resolve the conflict, uninstall it first:\\033[0m\\n    " \
      "brew uninstall teleport\\n\\nThen retry the installation of teleport-cli.\\n' >&2; " \
      "exit 1; fi",
    ]
  end

  def caveats
    <<~EOS
        For initial authentication to teleport server, run following:

            \e[1;32mtsh login --proxy=teleport.happening.dev\e[0m

    EOS
  end

  uninstall pkgutil: [
               "com.gravitational.teleport",
               "QH8AA5B8UP.com.gravitational.teleport.tsh",
               "QH8AA5B8UP.com.gravitational.teleport.tctl",
             ],
             delete: [
               "/Applications/tsh.app",
               "/Applications/tctl.app",
             ]
  zap trash: "~/.tsh"
end
