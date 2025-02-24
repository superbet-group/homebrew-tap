cask "teleport-cli" do
  name "Teleport enterprise utilities"
  desc "Access proxy providing access to k8s, aws, apps, dbs and servers through ssh and rdp"
  homepage "https://goteleport.com/"

  version "17.2.8"
  sha256 "3ae95100978e0dc7e0ecd7d61114d82a4c2fcefbe8c6e56a084811d3164fc07e"

  url "https://cdn.teleport.dev/teleport-ent-#{version}.pkg",
      verified: "cdn.teleport.dev/"

  livecheck do
    url "https://goteleport.com/download/"
    regex(/teleport-ent[._-]v?(\d+(?:\.\d+)+)\.pkg/i)
  end

  conflicts_with cask:    "tsh",
                 formula: "teleport"

  pkg "teleport-ent-#{version}.pkg"

  def caveats
    <<~EOS
        For initial authentication to teleport server, run following:

            \e[1;32mtsh login --proxy=teleport.happening.dev\e[0m

    EOS
  end

  uninstall pkgutil: "com.gravitational.teleport"
  zap trash: "~/.tsh"
end
