{ pkgs, lib, ... }:
{
  # default wayland
  services.xserver.displayManager.defaultSession = "plasmawayland";

  programs.ssh.askPassword = lib.mkForce "${pkgs.libsForQt5.plasma5.ksshaskpass.out}/bin/ksshaskpass}";
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    useQtScaling = true;
    phononBackend = "vlc";
  };

  environment.systemPackages = with pkgs;[
    libsForQt5.bismuth #plasma tiling
  ];

  programs.dconf.enable = true;
}
