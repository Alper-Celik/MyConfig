{ config, pkgs, ... }:
{
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = config.services.openssh.ports;
  services.openssh = {
    enable = true;
    openFirewall = false; # set it up so it is only accessible in tailscale
    settings = {
      X11Forwarding = true;
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };
  environment.systemPackages = [ pkgs.waypipe ];
}
