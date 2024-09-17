{ pkgs, ... }:
{
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.gnome.excludePackages = (
    with pkgs;
    [
      # for packages that are pkgs.*
      # gnome-tour
      gnome-connections
      epiphany # web browser
      evince
      file-roller
      geary
      gnome-disk-utility
    ]
  );

}
