{ pkgs, ... }:
{

  environment.persistence."/persistent".directories = [ "/var/lib/tailscale" ];
  environment.systemPackages = [ pkgs.ktailctl ];

  systemd.user.services.ktailscale = {
    enable = true;
    description = "autostart ktailctl";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ktailctl}/bin/ktailctl";
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.interfaces.tailscale0.useDHCP = false;
}
