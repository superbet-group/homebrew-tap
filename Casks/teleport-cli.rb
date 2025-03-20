cask "teleport-cli" do
  name "Teleport enterprise utilities"
  desc "Access proxy providing access to k8s, aws, apps, dbs and servers through ssh and rdp"
  homepage "https://goteleport.com/"

  version "17.3.4"
  sha256 "ce21a6df02c54d026142224054e02ba023bd816fddba6ae03ab37320f807551d"

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
