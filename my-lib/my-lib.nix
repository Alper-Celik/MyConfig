{ lib }:
with builtins; let
  all-lib-files = map (f: ./${f}) (attrNames (removeAttrs (readDir ./.) [ "my-lib.nix" ]));
  my-lib = foldl' (attrs: file: attrs // (import file { inherit lib my-lib; })) { } all-lib-files;
in
my-lib
