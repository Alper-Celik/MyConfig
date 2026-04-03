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
  wm-target = "wayland-wm@niri\x2dsession.service";
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
    };
    Service = {
      RestartSec = "0.5s";
      Type = "notify";
      NotifyAccess = "all";
    };
  };

}
