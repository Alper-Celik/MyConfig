{ config, lib, pkgs, ... }: {
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.gdm.enable = true;
}
