let
  files = builtins.removeAttrs (builtins.readDir ./.) [ "allOverlays.nix" ];
  overlay-files = builtins.attrNames files;
  overlays = map (fileName: import ./${fileName}) overlay-files;
in
overlays
