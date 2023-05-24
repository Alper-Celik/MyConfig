{ inputs, pkgs, ... }:
{

  programs.hyprland = {
    enable = true;
    xwayland = { enable = true; hidpi = true; };
    nvidiaPatches = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
}
