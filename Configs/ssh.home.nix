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
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };

}
