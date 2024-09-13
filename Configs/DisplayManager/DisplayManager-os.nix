{
  config,
  lib,
  pkgs,
  ...
}:
{
  # services.xserver.displayManager.gdm.wayland = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    autoNumlock = true;
  };
}
