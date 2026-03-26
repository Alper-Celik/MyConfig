{
  inputs,
  pkgs,
  config,
  lib,
  specialArgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
    nix-tree
  ];

  programs.nh = {
    enable = true;
    flake = lib.mkIf (builtins.hasAttr "configDir" specialArgs) specialArgs.configDir;
  };

  nix = {

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 6;
    settings = {
      trusted-users = [ "alper" ];
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    }
    // specialArgs.caches;
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d --max-freed 10G";
    # };
  };

  systemd.services.nix-daemon.serviceConfig = {
    CPUQuota = "85%";
    Nice = 10;
  };

  #use lix
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];
  nix.package = pkgs.lixPackageSets.stable.lix;

}
