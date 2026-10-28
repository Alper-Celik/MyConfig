{
  config,
  lib,
  my-pkgs,
  pkgs,
  ...
}:
let
  decky = config.jovian.decky-loader;

  # Pinned by ./update-decky-plugins.py from decky-plugins.txt: the exact
  # hash-addressed artifacts the Decky store installs, with the plugin directory
  # name recorded from the zip.
  pluginPins = import ./decky-plugins.nix;
  declaredPlugins = lib.mapAttrsToList (name: pin: pin // { inherit name; }) pluginPins;

  pluginSources = map (
    p:
    p
    // {
      src = pkgs.stdenvNoCC.mkDerivation {
        pname = "decky-plugin-${p.dir}";
        inherit (p) version;
        src = pkgs.fetchurl { inherit (p) url hash; };
        nativeBuildInputs = [ pkgs.unzip ];
        dontBuild = true;
        # Updater guarantees a single top-level directory; -o because some store
        # zips ship duplicate entries that plain unzip prompts about.
        unpackPhase = ''
          runHook preUnpack
          mkdir source
          ${pkgs.unzip}/bin/unzip -q -o "$src" -d source
          runHook postUnpack
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p "$out"
          cp -r -- source/*/. "$out"
          runHook postInstall
        '';
      };
    }
  ) declaredPlugins;

  installPlugins = pkgs.writeShellScript "decky-loader-plugins" ''
    set -eu
    plugins_dir=${lib.escapeShellArg "${decky.stateDir}/plugins"}
    manifest=$plugins_dir/.managed
    new_manifest=$manifest.new

    mkdir -p "$plugins_dir"
    chown ${lib.escapeShellArg decky.user}: "$plugins_dir"

    : > "$new_manifest"
    ${lib.concatMapStrings (name: "printf '%s\\n' ${lib.escapeShellArg name} >> \"$new_manifest\"\n") (map (p: p.dir) pluginSources)}
    touch "$manifest"

    # Drop plugins that a previous generation installed but this one no longer declares.
    while IFS= read -r name; do
      [ -n "$name" ] || continue
      if ! grep -Fxq -- "$name" "$new_manifest"; then
        rm -rf -- "$plugins_dir/$name"
      fi
    done < "$manifest"

    ${lib.concatMapStrings (p: ''
      # Replace store-installed copies; the loader follows the symlink and skips
      # its own chown because the target is store-owned (root).
      rm -rf -- "$plugins_dir"/${lib.escapeShellArg p.dir}
      ln -sfn ${p.src} "$plugins_dir"/${lib.escapeShellArg p.dir}
    '') pluginSources}
    mv "$new_manifest" "$manifest"
  '';
in
{
  jovian.decky-loader = {
    enable = true;
    # Run plugins as the session user rather than the synthetic `decky` user.
    user = config.jovian.steam.user;
    # Binaries plugin backends shell out to: Quick Launch lists flatpaks,
    # Tailscale Control drives `tailscale`, Music Control `dbus-send`,
    # vibrantDeck `xprop`.
    extraPackages = [
      pkgs.dbus
      pkgs.flatpak
      pkgs.tailscale
      pkgs.xorg.xprop
    ];
  };

  # Quick Launch reads .desktop files from /usr/share/applications, which does
  # not exist on NixOS; point it at the system profile copy.
  systemd.tmpfiles.rules = [
    "L+ /usr/share/applications - - - - /run/current-system/sw/share/applications"
  ];

  # Default the gaming session to zink: GL clients get a Vulkan swapchain, so
  # implicit Vulkan layers (frame generation, vkBasalt, MangoHud) apply to them
  # too. Proton/DXVK games are Vulkan already and unaffected. Measured here:
  # glmark2 off-screen is ~22% slower than radeonsi. Escape hatch per game:
  #   MESA_LOADER_DRIVER_OVERRIDE=radeonsi %command%
  jovian.steam.environment.MESA_LOADER_DRIVER_OVERRIDE = "zink";

  # Same for the desktop sessions on this deck (niri + every GL client in it),
  # so apps like Kodi/Fladder are on Vulkan too. Experimental: a broken session
  # is recoverable via a TTY and `nixos-rebuild switch --rollback`.
  environment.sessionVariables.MESA_LOADER_DRIVER_OVERRIDE = "zink";

  # Frame generation layers.
  # lsfg-vk: upstream, store-pinned, implicit layer gated on profile `active_in`
  # matches; lsfg-vk-ui configures profiles, lsfg-vk-cli validates.
  # MAKO: built from source in my-pkgs; only activates under its own
  # `mako-launch` wrapper (per-game launch option), which exports
  # DISABLE_LSFGVK=1 so the two never chain in one process.
  # Both need a licensed Lossless Scaling: lsfg-vk wants the `lsfg-vk` beta
  # branch (lsfg-vk.dll), MAKO the default branch (Lossless.dll) - one branch
  # at a time on the Steam app.
  hardware.graphics.extraPackages = [ pkgs.lsfg-vk ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.lsfg-vk ];
  environment.systemPackages = [
    pkgs.lsfg-vk-ui
    my-pkgs.mako-renderer
  ];

  # Jovian deliberately does not create Steam's CEF remote-debugging marker:
  # once Steam sees it, debugging cannot be disabled again without wiping the
  # Steam root. Decky Loader needs it to inject into the Steam UI, so create it
  # from a oneshot unit instead of touching it imperatively.
  systemd.services.steam-cef-remote-debugging = lib.mkIf decky.enable {
    description = "Enable CEF remote debugging for the Steam client (Decky Loader)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = config.jovian.steam.user;
      ExecStart = pkgs.writeShellScript "steam-cef-remote-debugging" ''
        set -eu
        # The marker is read relative to the Steam root; create it there even on
        # a first boot where Steam has not created the root yet.
        steam_root="$HOME/.local/share/Steam"
        ${pkgs.coreutils}/bin/mkdir -p "$steam_root"
        ${pkgs.coreutils}/bin/touch "$steam_root/.cef-enable-remote-debugging"
        if [ -e "$HOME/.steam/steam" ]; then
          ${pkgs.coreutils}/bin/touch "$HOME/.steam/steam/.cef-enable-remote-debugging"
        fi
      '';
    };
  };

  # Declarative plugins are symlinked into the loader's plugin dir before it
  # starts; plugins installed from the Decky store keep working independently.
  systemd.services.decky-loader-plugins = lib.mkIf decky.enable {
    description = "Install declaratively managed Decky Loader plugins";
    wantedBy = [ "multi-user.target" ];
    before = [ "decky-loader.service" ];
    path = [
      pkgs.coreutils
      pkgs.gnugrep
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = installPlugins;
    };
  };

  # Decky plugins live in the loader's state dir, which is on the ephemeral
  # root subvolume otherwise.
  environment.persistence."/persistent".directories = [ "/var/lib/decky-loader" ];
}
