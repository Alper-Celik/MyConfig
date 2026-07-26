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
  current-dir = "Configs/DMS";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  xdg.configFile.DankMaterialShell.source = outOfStrore ".";
}
