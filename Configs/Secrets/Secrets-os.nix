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
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      alper-password = {
        neededForUsers = true;
      };
    };
  };
}
