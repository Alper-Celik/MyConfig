inputs:
let
  files = builtins.removeAttrs (builtins.readDir ./.) [ "allOverlays.nix" ];
  # Only regular .nix files are overlays — the directory also holds patch files.
  overlay-files = builtins.filter (
    name: files.${name} == "regular" && builtins.match ".*\\.nix" name != null
  ) (builtins.attrNames files);
  overlays = map (fileName: (import ./${fileName}) inputs) overlay-files;
in
overlays
++ [
  # inputs.Quickshell-master.overlays.default
]
