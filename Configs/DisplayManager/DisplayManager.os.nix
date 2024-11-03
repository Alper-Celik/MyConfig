{
  config,
  lib,
  pkgs,
  ...
}:
{

  specialisation.Gnome.configuration = {
    programs.dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
          remember-numlock-state = true;
        };
      }
    ];
    services.xserver.displayManager.gdm = {
      wayland = true;
      enable = true;
    };
  };

  specialisation.Kde.configuration = {
    services.displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
        # compositor = "kwin";
      };
      autoNumlock = true;
    };
  };
}
