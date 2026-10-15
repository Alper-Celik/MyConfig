{ config, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    tray = {
      enable = !config.x-headless;
      package = pkgs.syncthingtray;
    };
  };
}
