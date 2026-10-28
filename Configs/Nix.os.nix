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

    # Builds must never outrank the compositor. SCHED_BATCH and the idle I/O
    # class are inherited by everything the daemon forks (rustc, cc1, ld), so a
    # compile tree yields to interactive work without any per-tool wrapper.
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
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
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d --max-freed 10G";
    # };
  };

  # Weights, not CPUQuota: a quota is a percentage of *one* core for the whole
  # daemon (85% = all builds capped at 0.85 core), while weights only bite under
  # contention — full 8-thread speed when the desktop is idle, ~1/5 of a busy
  # CPU when it is not. Weight and nice are inherited by every builder.
  systemd.services.nix-daemon.serviceConfig = {
    CPUWeight = 20;
    IOWeight = 20;
    Nice = 15;
    OOMScoreAdjust = 1000; # a build dies before the compositor does
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
