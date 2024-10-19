{
  inputs,
  pkgs,
  config,
  ...
}:
let
  secrets = inputs.MyConfigSecrets;
  config_sops = config.sops;
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
      alper-sops-age-key = {
        owner = config.users.users.alper.name;
      };
      alper-password = {
        neededForUsers = true;
      };
    };
  };

  home-manager.users.alper =
    { config, ... }:
    {
      xdg.configFile."sops/age/keys.txt".source = config.lib.file.mkOutOfStoreSymlink config_sops.secrets.alper-sops-age-key.path;
    };
}
