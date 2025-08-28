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

  preflight do
    conflicting_packages = []
    conflicting_casks = []
    conflicting_formulas = []

    if system("brew list --cask tsh > /dev/null 2>&1")
      conflicting_packages << "tsh (cask)"
      conflicting_casks << "tsh"
    end

    if system("brew list teleport > /dev/null 2>&1")
      conflicting_packages << "teleport (formula)"
      conflicting_formulas << "teleport"
    end

    unless conflicting_packages.empty?
      error_message = <<~EOS
        \e[1;31mConflicting packages detected:\e[0m #{conflicting_packages.join(", ")}

        \e[1;33mTo resolve conflicts, please uninstall them first:\e[0m
      EOS

      conflicting_casks.each do |cask|
        error_message += "    brew uninstall --cask #{cask}\n"
      end

      conflicting_formulas.each do |formula|
        error_message += "    brew uninstall #{formula}\n"
      end

      error_message += "\nThen retry the installation of teleport-cli."

      odie error_message
    end
  end

  def caveats
    <<~EOS
        For initial authentication to teleport server, run following:

            \e[1;32mtsh login --proxy=teleport.happening.dev\e[0m

    EOS
  end

  uninstall pkgutil: "com.gravitational.teleport"
  zap trash: "~/.tsh"
end
