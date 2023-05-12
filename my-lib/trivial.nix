{ ... }:
with builtins;{
  endsWith = x: y: (
    let
      y-length = stringLength y;
      x-length = stringLength x;
    in
    substring (x-length - y-length) y-length x
  ) == y;

}
