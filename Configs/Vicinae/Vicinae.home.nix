{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.vicinae = {
    #package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
    useLayerShell = true;
    enableFirefoxIntegration = true;
    systemd = {
      enable = true;
    };

    settings = {

      launcher_window = {
        opacity = 0.8;
      };
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix
      power-profile
    ];
  };

}
