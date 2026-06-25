{
  inputs,
  pkgs,
  config,
  my-lib,
  specialArgs,
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
    systemd.enable = true;
  };

  xdg.configFile.noctalia.source = outOfStrore ".";
}
