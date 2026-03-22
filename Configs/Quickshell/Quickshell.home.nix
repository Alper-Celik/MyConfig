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
  hyprland-target = "wayland-session@Hyprland.target";
  current-dir = "Configs/Quickshell";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  home.packages = with pkgs; [
    grim
  ];

  xdg.configFile."quickshell".source = outOfStrore ".";
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
    systemd = {
      enable = true;
      target = hyprland-target;
    };
  };

  systemd.user.services.quickshell = {
    Unit = rec {
      StartLimitIntervalSec = 0;
      Before = Wants;
      Wants = [
        "xdg-desktop-autostart.target"
      ];
      Requires = After;
      After = [
        "wayland-session@Hyprland.target"
        "wayland-wm@Hyprland.service"
        hyprland-target
      ];
    };
    Service = {
      RestartSec = "0.5s";
      Type = "notify";
      NotifyAccess = "all";
    };
  };

}
