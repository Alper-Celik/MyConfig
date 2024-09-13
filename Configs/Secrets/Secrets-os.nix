{ inputs, pkgs, ... }:
let
  secrets = inputs.MyConfigSecrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops = {
    defaultSopsFile = "${secrets}/secrets/secrets.yaml";
    age.keyFile = "/home/alper/.config/sops/age/keys.txt";

    secrets = {
      alper-password = {
        neededForUsers = true;
      };
    };
  };
}
