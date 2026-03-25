{
  config,
  my-lib,
  my-pkgs,
  specialArgs,
  inputs,
  pkgs,
  ...
}:
let
  current-dir = "Configs/Hyprland";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text = ''
    [preferred]
    default = hyprland;gtk
    org.freedesktop.impl.portal.FileChooser = kde
  '';

  xdg.configFile."hypr".source = outOfStrore ".";
  services.hyprpolkitagent.enable = true;
  home.packages = with pkgs; [
    playerctl
    brightnessctl
  ];

  home.sessionPath = [
    "${(outOfStrore "./scripts/")}"
  ];
  home.sessionVariables = {
    HYPRLAND_NO_SD_VARS = 1;
    HYPRLAND_NO_SD_NOTIFY = 1;
  };

  wayland.windowManager.hyprland.systemd.enable = false;

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

  services.dunst = {
    enable = true;
  };

}
