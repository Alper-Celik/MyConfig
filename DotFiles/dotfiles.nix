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
  dotfiles = builtins.removeAttrs (builtins.readDir ./.) [ "dotfiles.nix" ];
  current-dir = "DotFiles";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  home.file = builtins.mapAttrs (file: _: { source = outOfStrore file; }) dotfiles;
}
