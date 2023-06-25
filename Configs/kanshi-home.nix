{ specialArgs, pkgs, ... }:
if specialArgs.hardware == "lenovo-ideapad-510" then
  {
    home.packages = with pkgs; [ kanshi ];
    services.kanshi = {
      systemdTarget = "non-existent.target";
      enable = true;
      profiles = {

        docked = {
          outputs = [
            { criteria = "eDP-1"; status = "disable"; }
            { criteria = "DP-1"; status = "enable"; mode = "1400x900@60Hz"; }
          ];
        };

        undocked = {
          outputs = [
            { criteria = "eDP-1"; status = "enable"; }
          ];
        };

      };
    };
  }
else { }
