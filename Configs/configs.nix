{ inputs, lib, config, pkgs, specialArgs, ... }:
let
  all-inodes = builtins.removeAttrs (builtins.readDir ./.) [ "configs.nix" ];
  flat-files = lib.filterAttrs (_: inode-type: inode-type == "regular") all-inodes;
  all-dirs = lib.filterAttrs (_: inode-type: inode-type == "directory") all-inodes;

  dir-files = map (f: ./${f}/${f}.nix) (builtins.attrNames all-dirs);
  flat-files' = map (f: ./${f}) (builtins.attrNames flat-files);
  all-nix-files = dir-files ++ flat-files';
in
{
  imports = all-nix-files;
}
