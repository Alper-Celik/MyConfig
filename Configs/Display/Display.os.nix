{
  system,
  ...
}:
{
  hardware.graphics = {
    enable32Bit = if system == "x86_64-linux" then true else false;
    enable = true;
  };

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
