{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.fastfetch = {
    enable = true;
    settings = (lib.importJSON "${inputs.fastfetch-theme}/config.jsonc") // {
      "logo" = rec {
        "type" = "kitty-direct";
        "source" = "${pkgs.nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png";
        "height" = 20;
        "width" = height * 2;
        "padding" = {
          "right" = 6;
          "left" = 4;
          "top" = 3;
        };
      };
    };
  };
}
