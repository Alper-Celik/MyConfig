{ pkgs, my-lib, ... }:
let
  package-files = my-lib.getConfigs { removed-files = [ "my-pkgs.nix" ]; base-dir = ./.; };
  my-pkgs = builtins.foldl'
    (pkg-set: pkg-file:
      let
        pkg = pkgs.callPackage pkg-file { };
      in
      pkg-set // { "${pkg.pname}" = pkg; })
    { }
    package-files;
in
my-pkgs 
