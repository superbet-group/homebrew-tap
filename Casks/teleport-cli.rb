cask "teleport-cli" do
  version "18.3.2"
  sha256 "bbe83f4f638828ad2bd9f818aaa3fdcf31a02c89ec3a713408e5cfc62f098b20"

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

  # Preflight block prevents installation conflicts with existing teleport-related packages.
  # This is necessary because multiple teleport packages can install the same binaries (tsh, tctl)
  # in /usr/local/bin/, leading to broken symlinks when one package is uninstalled.
  preflight do
    conflicting_casks = []
    conflicting_formulas = []

    # Collect all potential teleport-related packages from multiple sources
    potential_casks = []
    potential_formulas = []

    # 1. Official Homebrew Casks - query Homebrew API for casks with goteleport.com homepage
    #    This catches packages like: teleport-suite, teleport-connect, tsh, etc.
    official_casks = `curl -s "https://formulae.brew.sh/api/cask.json" | jq -r '.[] | select(.homepage | test("goteleport.com")) | .token' 2>/dev/null`.strip.split("\n").reject(&:empty?)
    potential_casks.concat(official_casks)

    # 2. Official Homebrew Formulas - query Homebrew API for formulas with goteleport.com homepage
    #    This catches packages like: teleport formula
    official_formulas = `curl -s "https://formulae.brew.sh/api/formula.json" | jq -r '.[] | select(.homepage | test("goteleport.com")) | .name' 2>/dev/null`.strip.split("\n").reject(&:empty?)
    potential_formulas.concat(official_formulas)

    # 3. Custom taps - scan local tap repositories for teleport-related packages
    #    This is needed because custom taps are not included in official Homebrew API
    #    We look for packages that contain: tsh, tctl binaries or teleport domains
    Dir.glob("/opt/homebrew/Library/Taps/*/*/*.rb").each do |rb_file|
      content = File.read(rb_file) rescue next
      # Use word boundaries (\b) to avoid false positives like "betctl" matching "tctl"
      if content.match?(/(\btsh\b|\btctl\b|goteleport|cdn\.teleport)/)
        if match = content.match(/^cask\s+"([^"]+)"/)
          potential_casks << match[1]
        elsif match = content.match(/^class\s+(\w+)\s+<\s+Formula/)
          potential_formulas << match[1].downcase
        end
      end
    end

    # Clean up the collected package lists
    potential_casks.uniq!
    potential_casks.delete("teleport-cli")  # Don't conflict with ourselves
    potential_formulas.uniq!

    # Check which of the potential packages are actually installed
    # Note: We use absolute path to brew because preflight runs in a restricted context
    # where PATH may not include homebrew binaries. Support both Intel and Apple Silicon.
    brew_path = File.exist?("/opt/homebrew/bin/brew") ? "/opt/homebrew/bin/brew" : "/usr/local/bin/brew"

    potential_casks.each do |cask|
      if system("#{brew_path} list --cask #{cask} > /dev/null 2>&1")
        conflicting_casks << cask
      end
    end

    potential_formulas.each do |formula|
      if system("#{brew_path} list #{formula} > /dev/null 2>&1")
        conflicting_formulas << formula
      end
    end

    # If conflicts are found, abort installation with detailed instructions
    # Using 'raise' instead of 'odie' because it properly triggers Homebrew's cleanup
    # mechanism, preventing partial registration of the cask
    unless conflicting_casks.empty? && conflicting_formulas.empty?
      all_conflicts = conflicting_casks.map { |c| "#{c} (cask)" } +
                     conflicting_formulas.map { |f| "#{f} (formula)" }

      error_message = <<~EOS
        \e[1;31mConflicting packages detected:\e[0m #{all_conflicts.join(", ")}

        \e[1;33mTo resolve conflicts, please uninstall them first:\e[0m
      EOS

      conflicting_casks.each do |cask|
        error_message += "    brew uninstall --cask #{cask}\n"
      end

      conflicting_formulas.each do |formula|
        error_message += "    brew uninstall #{formula}\n"
      end

      error_message += "\nThen retry the installation of teleport-cli."

      raise error_message
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
