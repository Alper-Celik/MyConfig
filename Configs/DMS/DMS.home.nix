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
  # dms-shell 2.0 reads ~/.config/dms; linking there directly keeps the repo live and
  # avoids the shell's own legacy-DankMaterialShell migration creating a second symlink.
  xdg.configFile.dms.source = outOfStrore ".";
}
