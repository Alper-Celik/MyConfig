{ pkgs, ... }:
{

  environment.persistence."/persistent".directories = [ "/var/lib/tailscale" ];
  environment.systemPackages = [
    pkgs.ktailctl
  ];

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

  networking.nameservers = [
    "100.100.100.100"
    "8.8.8.8"
    "1.1.1.1"
  ];
  networking.search = [ "example.ts.net" ];
}
