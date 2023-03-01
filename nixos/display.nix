{ inputs, lib, config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  programs.xwayland.enable = true;

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
  };

  environment.systemPackages = with pkgs;[
    libsForQt5.bismuth #plasma tiling
    orca
  ];


  # Enable the Plasma 5 Desktop Environment.

  # default wayland
  # services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.lightdm.greeters.enso = {
  #   enable = true;
  # };
  services.gnome.at-spi2-core.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;
    flashback.enableMetacity = true;
  };

  programs.ssh.askPassword = lib.mkForce "${pkgs.libsForQt5.plasma5.ksshaskpass.out}/bin/ksshaskpass}";
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    useQtScaling = true;
    phononBackend = "vlc";
  };



  programs.dconf.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

}
