{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:
let
  dotfiles = builtins.removeAttrs (builtins.readDir ./.) [ "dotfiles.nix" ];
in
{
  home.file = builtins.mapAttrs (file: _: { source = ./${file}; }) dotfiles;
}
