{ system, lib, ... }: {

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
    buildMachines = [
      # foreign-arch offload, unfiltered (unchanged behavior)
      {
        hostName = "eu.nixbuild.net";
        system =
          if system == "x86_64-linux" then
            "aarch64-linux"
          else if system == "aarch64-linux" then
            "x86_64-linux"
          else
            "";
        maxJobs = 100;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "ca-derivations"
          "kvm"
          "nixos-test"
        ];
      }
    ]
    # native heavy builds: only derivations requiring `big-parallel` route
    # here (mandatoryFeatures), everything else stays local. x86_64-only,
    # because the aarch64 host has no local x86_64 builder to fall back on.
    ++ lib.optionals (system == "x86_64-linux") [
      {
        hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "ca-derivations"
          "kvm"
          "nixos-test"
        ];
        mandatoryFeatures = [ "big-parallel" ];
      }
    ];
  };
}
