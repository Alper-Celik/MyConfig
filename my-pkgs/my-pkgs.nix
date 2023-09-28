{ pkgs, my-lib, ... }:
let
  package-files = my-lib.getConfigs { removed-files = [ "my-pkgs.nix" ]; base-dir = ./.; };
  my-pkgs = builtins.foldl' (pkg-set: pkg-file: pkg-set // { ${builtins.baseNameOf "${pkg-file}"} = (import pkg-file); }) { } package-files;
in
my-pkgs
