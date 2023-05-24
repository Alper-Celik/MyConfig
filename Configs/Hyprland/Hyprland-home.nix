{ inputs, pkgs, config, specialArgs, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.waybar-hyprland;
    systemd.enable = false;
  };
  xdg.configFile."waybar/config".source = config.lib.file.mkOutOfStoreSymlink (
    # TODO: extract to lib somehow
    if builtins.hasAttr "configDir" specialArgs
    then "${specialArgs.configDir}/Configs/Hyprland/waybar.json"
    else ./waybar.json
  );

  services.dunst.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    nvidiaPatches = true;

    recommendedEnvironment = true;
    systemdIntegration = false;
    extraConfig = ''
      exec-once=${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      source=../hypr-user/config-loader.conf
    '';
  };

  xdg.configFile.hypr-user.source = config.lib.file.mkOutOfStoreSymlink (
    # TODO: extract to lib somehow
    if builtins.hasAttr "configDir" specialArgs
    then "${specialArgs.configDir}/Configs/Hyprland"
    else ./.
  );
}
