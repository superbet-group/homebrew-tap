cask "teleport-cli" do
  name "Teleport enterprise utilities"
  desc "Access proxy providing access to k8s, aws, apps, dbs and servers through ssh and rdp"
  homepage "https://goteleport.com/"

  version "17.5.2"
  sha256 "5c89b293f0f914fe35ceb04995d99ef0e91a54182833be4acae23472ce041d59"

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
