{
  lib,
  hardware,
  pkgs,
  ...
}:
{

  environment.persistence."/persistent".directories = [
    "/var/lib/tailscale"
    "/etc/mullvad-vpn/"
  ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  networking.interfaces.tailscale0.useDHCP = false;
  networking.nftables = {
    enable = true;
  };
  networking.nftables.tables.tailscale-mulvad = {
    family = "inet";
    content = ''
      chain excludeOutgoing {
        type route hook output priority 0; policy accept;
        ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    '';
  };
  virtualisation.docker.daemon.settings."firewall-backend" = "nftables";

  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  networking.hostName = hardware; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  # networking.networkmanager.dns = "none";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  services.resolved = {
    enable = true;
  };
}
