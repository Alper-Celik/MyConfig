{
  pkgs,
  my-lib,
  inputs,
  ...
}@args:
let
  package-files = my-lib.getConfigs {
    removed-files = [ "my-pkgs.nix" ];
    base-dir = ./.;
  };
  my-pkgs = builtins.foldl' (
    pkg-set: pkg-file:
    let
      pkg = (import pkg-file) {
        inherit
          inputs
          args
          pkgs
          ;
      };
    in
    pkg-set // { "${pkg.pname}" = pkg; }
  ) { } package-files;
in
my-pkgs
