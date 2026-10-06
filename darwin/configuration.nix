# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nix-darwin/configuration.nix)

{
  inputs,
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}:

{
  imports = [ ../Configs/configs.mac.nix ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix = {
    settings = {
      trusted-users = [ "alper" ];
      # Enable flakes and new 'nix' command
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    }
    // specialArgs.caches;
  };

  # List services that you want to enable:

  # This value determines the nix-darwin release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = 5;
}
