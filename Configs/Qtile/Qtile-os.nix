{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;[
    alsa-utils

    rofi-wayland # works on x11 too
    rofimoji
    rofi-calc
    rofi-bluetooth
    rofi-power-menu

  ];

  programs.light.enable = true;
  users.users.alper.extraGroups = [ "video" ];

  # services.picom = {
  #   enable = true;
  #   vSync = true;
  #   backend = "glx";
  # };

  services.xserver = {
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
      ];
      backend = "x11";
    };
  };
}
