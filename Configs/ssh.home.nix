{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "rpi5.devices.alper-celik.dev" = {
        # port = 110;
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519_sk
      IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
