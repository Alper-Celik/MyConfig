{ inputs, pkgs, lib, my-lib, config, specialArgs, ... }:
let
  current-dir = "Configs/Hyprland";
  outOfStrore = x: config.lib.file.mkOutOfStoreSymlink
    (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = [
    pkgs.avizo # osd
    pkgs.pavucontrol # sound settings
  ];

  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.waybar-hyprland;
    systemd.enable = false;
  };

  xdg.configFile."avizo/config.ini".source = outOfStrore "avizo-config.ini";
  xdg.configFile."waybar/config".source = outOfStrore "waybar.json";

  services.dunst.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    nvidiaPatches = true;

    recommendedEnvironment = true;
    systemdIntegration = false;
    extraConfig = ''
      exec-once=avizo-service
      exec-once=${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      source=../hypr-user/config-loader.conf
    '';
  };

  xdg.configFile.hypr-user.source = outOfStrore ".";
}
