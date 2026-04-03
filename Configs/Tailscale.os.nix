{ pkgs, ... }:
{

  environment.persistence."/persistent".directories = [ "/var/lib/tailscale" ];
  environment.systemPackages = [ pkgs.ktailctl ];

  systemd.user.services.ktailscale = {
    enable = true;
    description = "autostart ktailctl";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig = {
      StartLimitIntervalSec = 0;
    };
    serviceConfig = {
      ExecStart = "${pkgs.ktailctl}/bin/ktailctl";
      RestartSec = "2s";
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.interfaces.tailscale0.useDHCP = false;
}
