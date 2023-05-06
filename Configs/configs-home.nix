{ inputs, lib, config, pkgs, specialArgs, ... }:
with builtins; let
  endsWith = x: y: (
    let
      y-length = stringLength y;
      x-length = stringLength x;
    in
    substring (x-length - y-length) y-length x
  ) == y;

  all-inodes = removeAttrs (readDir ./.) [ "configs.nix" "configs-home.nix" ];
  flat-files = lib.filterAttrs (_: inode-type: inode-type == "regular") all-inodes;
  home-flat-files = filter (x: endsWith x "-home.nix") (attrNames flat-files);
  all-dirs = lib.filterAttrs (_: inode-type: inode-type == "directory") all-inodes;

  home-dir-files = map (f: ./${f}/${f}-home.nix) (attrNames all-dirs);
  home-dir-files' = filter (f: pathExists f) home-dir-files;
  home-flat-files' = map (f: ./${f}) home-flat-files;
  home-nix-files = home-dir-files' ++ home-flat-files';
in
{
  imports = home-nix-files;
}
