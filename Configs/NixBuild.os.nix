{ system, ... }: {

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
    ];
  };
}
