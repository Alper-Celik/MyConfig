{ inputs, pkgs, ... }:
{
  imports = [ inputs.vicinae.homeManagerModules.default ];
  services.vicinae = {
    enable = true;

    systemd = {
      enable = true;
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    settings = {

      launcher_window = {
        opacity = 0.8;
      };
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      bluetooth
      nix
      power-profile
      wifi-commander
      firefox
      hypr-keybinds
    ];
  };

}
