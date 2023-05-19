{ ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland = { enable = true; hidpi = true; };
    nvidiaPatches = true;
  };
}
