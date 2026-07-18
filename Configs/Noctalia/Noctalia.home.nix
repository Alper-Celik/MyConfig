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

  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${system}.default;
    settings = lib.mkForce { };
    systemd.enable = true;
  };

  xdg.configFile.noctalia.source = outOfStrore ".";
}
