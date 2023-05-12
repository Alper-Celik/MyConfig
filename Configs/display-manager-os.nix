{ ... }: {
  # default wayland
  # services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.gdm.enable = true;

}
