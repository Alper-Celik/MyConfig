{ inputs, pkgs, lib, my-lib, config, specialArgs, ... }:
let
  current-dir = "Configs/Hyprland";
  outOfStrore = x: config.lib.file.mkOutOfStoreSymlink
    (my-lib.maybeOutOfStore specialArgs current-dir x);
  wrapped-hyprland = (import ./wrap-hyprland.nix)
    {
      inherit (pkgs) rsync runCommand;
      hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

  fetch-walpaper = pkgs.writeShellApplication
    {
      name = "fetch-walpaper";

      runtimeInputs = with pkgs; [ curl jq ];

      text = ''
        curl -L 'https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US' \
        | jq ".images[0].url" -r \
        | sed "s/^/https:\/\/www.bing.com/" \
        | xargs curl -Lo lastest-bing.jpg
      '';
    };
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = [
    fetch-walpaper
    pkgs.rofi-wayland
    pkgs.avizo # osd
    pkgs.jq
    pkgs.swww
    pkgs.pavucontrol # sound settings
    pkgs.wlr-randr
  ];

  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.waybar-hyprland;
    systemd.enable = false;
  };

  xdg.configFile."avizo/config.ini".source = outOfStrore "avizo-config.ini";
  xdg.configFile."waybar/config".source = outOfStrore "waybar.json";

  services.dunst.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = wrapped-hyprland;
    nvidiaPatches = true;

    recommendedEnvironment = true;
    systemdIntegration = false;
    extraConfig = ''
      exec-once=avizo-service
      exec-once=${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      source=../hypr-user/config-loader.conf
    '';
  };

  xdg.configFile.hypr-user.source = outOfStrore ".";
}
