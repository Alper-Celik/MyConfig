{
  config,
  my-lib,
  my-pkgs,
  specialArgs,
  inputs,
  pkgs,
  system,
  ...
}:
let
  wm-target = "wayland-wm@niri.service";
  current-dir = "Configs/Quickshell";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  home.packages = with pkgs; [
    grim
  ];
  home.sessionPath = [
    "${(outOfStrore "./scripts/")}"
  ];

  xdg.configFile."quickshell".source = outOfStrore ".";
  programs.quickshell = {
    enable = true;
    package = inputs.Quickshell-master.packages.${system}.quickshell;
    systemd = {
      enable = true;
      target = wm-target;
    };
  };

  systemd.user.services.quickshell = {
    Unit = {
      StartLimitIntervalSec = 0;
      Requires = "wayland-wm@niri.service";
      Before = [
        "xdg-desktop-autostart.target"
        "wayland-session@niri.target"
      ];
    };
    Service = {
      RestartSec = "0.5s";
      Type = "notify";
      NotifyAccess = "all";
    };
  };

}
