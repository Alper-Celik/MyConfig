{ ... }:
{
  services.tailscale.enable = true;

  networking.nameservers = [
    "100.100.100.100"
    "8.8.8.8"
    "1.1.1.1"
  ];
  networking.search = [ "example.ts.net" ];
}
