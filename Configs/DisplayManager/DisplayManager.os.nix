{ config, lib, pkgs, ... }: {
  services.displayManager.defaultSession = "plasma";
  # programs.dconf.profiles.gdm.databases = [
  #   {
  #     settings."org/gnome/desktop/peripherals/keyboard" = {
  #       numlock-state = true;
  #       remember-numlock-state = true;
  #     };
  #   }
  # ];
  # services.xserver.displayManager.gdm = {
  #   wayland = true;
  #   enable = true;
  # };

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    autoNumlock = true;
  };
}
