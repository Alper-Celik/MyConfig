{ ... }:
{

  programs.light.enable = true;
  users.users.alper.extraGroups = [ "video" ];

  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
  };

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
