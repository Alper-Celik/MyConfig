{
  inputs,
  pkgs,
  lib,
  config,
  my-lib,
  specialArgs,
  ...
}:
let
  current-dir = "Configs/Vicinae";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
in
{
  programs.vicinae = {
    #package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
    enable = true;
    useLayerShell = true;
    enableFirefoxIntegration = true;
    systemd = {
      enable = true;
    };
    settings = lib.mkForce { };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix
      power-profile
      process-manager
      # bluetooth
      wifi-commander
      # systemd
      firefox
      niri
      player-pilot
      port-killer
      github
      flathub-search
      # dbus
      color-converter
      nerdfont-search
      wikipedia
      mullvad
      zoxide-recent-directories
      kaomojis
      niri-monitors
      dms-integration
      lorem-ipsum
    ];
  };

  xdg.configFile."vicinae".source = outOfStrore ".";

}
