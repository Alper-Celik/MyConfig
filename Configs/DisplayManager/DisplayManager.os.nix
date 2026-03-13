{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
        remember-numlock-state = true;
      };
    }
  ];
  services.displayManager.gdm = {
    wayland = true;
    enable = true;
  };

  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland = {
  #     enable = true;
  #     compositor = "kwin";
  #   };
  #   autoNumlock = true;
  # };
}
