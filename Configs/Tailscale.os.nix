{
  pkgs,
  lib,
  config,
  ...
}:
let
  isKde = if lib.elem "Kde" config.MyConfig.tags then true else false;
in
{

  environment.persistence."/persistent".directories = [ "/var/lib/tailscale" ];
  environment.systemPackages = [
    pkgs.ktailctl
    pkgs.trayscale
  ];

  systemd.user.services.tailscale-gui = {
    enable = isKde;
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
