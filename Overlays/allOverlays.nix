inputs:
let
  files = builtins.removeAttrs (builtins.readDir ./.) [ "allOverlays.nix" ];
  overlay-files = builtins.attrNames files;
  overlays = map (fileName: (import ./${fileName}) inputs) overlay-files;
in
overlays
++ [
  inputs.Quickshell-master.overlays.default
  inputs.nix-cachyos-kernel.overlays.default
]
