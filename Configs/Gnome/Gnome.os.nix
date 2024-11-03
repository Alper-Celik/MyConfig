{ pkgs, ... }:
{
  specialisation.Gnome.configuration = {
    environment.etc."specialisation".text = "Gnome";
    MyConfig.tags = [
      "Gnome"
      "Desktop"
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      dconf-editor
    ];

    services.xserver.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    programs.seahorse.enable = true;

    qt = {
      style = "adwaita-dark";
      enable = true;
      platformTheme = "gnome";
    };

  };
}
