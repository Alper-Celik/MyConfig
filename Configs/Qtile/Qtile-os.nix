{ ... }:
{
  services.xserver.windowManager.qtile = {
    enable = true;
    backend = "wayland";
    extraPackages = import ./python-pkgs.nix;
  };
}
