{ pkgs, my-lib, ... }:
let
  package-files = my-lib.getConfigs [ "my-pkgs.nix" ] ".nix" ./.;
  my-pkgs = builtins.foldl' (pkg-set: pkg-file: pkg-set // { ${builtins.baseNameOf "${pkg-file}"} = (import pkg-file); }) { } package-files;
in
my-pkgs
