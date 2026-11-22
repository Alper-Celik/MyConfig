{ lib, my-lib }:
with builtins;
{
  endsWith =
    string: suffix:
    let
      suffix-length = stringLength suffix;
      string-length = stringLength string;
    in
    if (string-length >= suffix-length) then
      (substring (string-length - suffix-length) suffix-length string) == suffix
    else
      false;

  endsWithAny =
    string: suffixes:
    let
      cheked-all = map (suffix: my-lib.endsWith string suffix) suffixes;
    in
    foldl' (x: y: x || y) false cheked-all;

  flattenListOfLists = xs: foldl' (x: y: x ++ y) [ ] xs;

  # Mark a derivation so it can only build on builders advertising (mandatory)
  # `big-parallel` -- e.g. nixbuild.net -- while small builds stay local.
  # Note: overrides the drv hash, so the package stops being a cache hit.
  markBigParallel =
    pkg:
    pkg.overrideAttrs (old: {
      requiredSystemFeatures = (old.requiredSystemFeatures or [ ]) ++ [ "big-parallel" ];
    });
}
