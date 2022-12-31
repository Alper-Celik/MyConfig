{ inputs, lib, config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
  };


  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Enable the Plasma 5 Desktop Environment.

  # default wayland
  # services.xserver.displayManager.defaultSession = "plasmawayland";
  # services.xserver.displayManager.sddm.enable = true;

  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.lightdm.greeters.enso = {
  #   enable = true;
  # };
  services.gnome.at-spi2-core.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.useQtScaling = true;
  services.xserver.desktopManager.plasma5.phononBackend = "vlc";



  programs.dconf.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

}
