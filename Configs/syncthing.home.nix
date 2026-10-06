{ pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    tray = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
      enable = true;
      package = pkgs.syncthingtray;
    };
  };
}
