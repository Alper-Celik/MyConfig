{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    package = null; #from os config
    xwayland.enable = false; #from os config

    recommendedEnvironment = true;
    systemdIntegration = true;
    extraConfig = ''
    '';

  };
}
