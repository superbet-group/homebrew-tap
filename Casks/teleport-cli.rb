cask "teleport-cli" do
  version "17.5.2"
  sha256 "5c89b293f0f914fe35ceb04995d99ef0e91a54182833be4acae23472ce041d59"

  url "https://cdn.teleport.dev/teleport-ent-#{version}.pkg",
      verified: "cdn.teleport.dev/"
  name "Teleport enterprise utilities"
  desc "Access proxy for k8s, aws, apps, dbs and servers via ssh/rdp"
  homepage "https://goteleport.com/"

  livecheck do
    url "https://goteleport.com/download/"
    regex(/teleport-ent[._-]v?(\d+(?:\.\d+)+)\.pkg/i)
  end

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
