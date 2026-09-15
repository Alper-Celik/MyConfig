{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-u,
  pkgs-s,
  specialArgs,
  my-lib,
  ...
}:
let
  configs = builtins.removeAttrs (builtins.readDir ./.) [ "XdgConfigFiles.nix" ];
  current-dir = "XdgConfigFiles";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  xdg.configFile = builtins.mapAttrs (file: _: { source = outOfStrore file; }) configs;
}
