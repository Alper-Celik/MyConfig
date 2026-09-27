{
  inputs,
  pkgs,
  config,
  my-lib,
  specialArgs,
  system,
  lib,
  ...
}:
let
  current-dir = "Configs/Noctalia";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  programs.noctalia = lib.mkIf (!config.x-headless) {
    enable = false;
    package = inputs.noctalia.packages.${system}.default;
    settings = lib.mkForce { };
    systemd.enable = true;
  };

  xdg.configFile.noctalia = lib.mkIf (!config.x-headless) {
    source = outOfStrore ".";
  };
}
