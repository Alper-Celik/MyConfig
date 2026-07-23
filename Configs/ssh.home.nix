{ config, ... }:
{
  programs.ssh = {
    enable = true;
    settings = {
      "rpi5.devices.alper-celik.dev" = {
        # port = 110;
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
      "*" = {
        IdentityFile = [
          "~/.ssh/id_ed25519_sk"
          "~/.ssh/id_ed25519"
        ];
      };
    };
    enableDefaultConfig = false;
  };

  services.ssh-agent = {
    enable = true;
  };
}
