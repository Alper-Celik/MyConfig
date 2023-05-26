{ inputs, pkgs, ... }:
let
  wrapped-hyprland = (import ./wrap-hyprland.nix) {
    inherit (pkgs) rsync runCommand;
    hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
in
{

  programs.hyprland = {
    enable = true;
    xwayland = { enable = true; hidpi = true; };
    nvidiaPatches = true;
    package = wrapped-hyprland;
  };
}
