{ ... }: {
  services.xserver.enable = true;
  programs.xwayland.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
}
