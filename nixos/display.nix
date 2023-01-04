{ inputs, lib, config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
  };



  # Enable the Plasma 5 Desktop Environment.

  # default wayland
  # services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.lightdm.greeters.enso = {
  #   enable = true;
  # };
  services.gnome.at-spi2-core.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.useQtScaling = true;
  services.xserver.desktopManager.plasma5.phononBackend = "vlc";

  ## tiling
  environment.systemPackages = with pkgs;[ libsForQt5.bismuth ];


  programs.dconf.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

}
