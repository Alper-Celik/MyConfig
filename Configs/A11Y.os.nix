{ pkgs, lib, ... }:
{

  environment.systemPackages = with pkgs; [ orca ];

  services.gnome.at-spi2-core.enable = true;
}
