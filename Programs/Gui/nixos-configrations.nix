{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:
{

  environment.systemPackages = import ./program-list.nix { inherit pkgs pkgs-u pkgs-s; nur = config.nur; };

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  programs.kclock.enable = true;
  programs.kdeconnect.enable = true;

  programs.partition-manager.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Steam needs this to find Proton-GE
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

  programs.weylus.users = [ "alper" ];
  programs.weylus.enable = true;
  programs.weylus.openFirewall = true;
}
