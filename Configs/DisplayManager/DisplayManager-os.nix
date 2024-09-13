{
  config,
  lib,
  pkgs,
  ...
}:
{
  # services.xserver.displayManager.gdm.wayland = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
}
