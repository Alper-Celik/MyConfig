{
  inputs,
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}:
{
  programs.kitty = {
    enable = true;
    shellIntegration = {
      mode = "enabled";
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    settings = {
      shell_integration = "enabled";
      allow_remote_control = true;

      repaint_delay = 3; # 333,33333333333333 fps
      input_delay = 1;
    };
    font = {
      package = (
        pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "JetBrainsMono"
          ];
        }
      );
      name = lib.mkForce "JetBrainsMono Nerd Font Mono";
      size = lib.mkForce 9;
    };

    extraConfig = ''
      # Nightfox colors for Kitty
      ## name: carbonfox
      ## upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/carbonfox/nightfox_kitty.conf

      background #161616
      foreground #f2f4f8
      selection_background #2a2a2a
      selection_foreground #f2f4f8
      url_color #25be6a

      # Cursor
      # uncomment for reverse background
      # cursor none
      cursor #f2f4f8

      # Border
      active_border_color #78a9ff
      inactive_border_color #535353
      bell_border_color #3ddbd9

      # Tabs
      active_tab_background #78a9ff
      active_tab_foreground #0c0c0c
      inactive_tab_background #2a2a2a
      inactive_tab_foreground #6e6f70

      # normal
      color0 #282828
      color1 #ee5396
      color2 #25be6a
      color3 #08bdba
      color4 #78a9ff
      color5 #be95ff
      color6 #33b1ff
      color7 #dfdfe0

      # bright
      color8 #484848
      color9 #f16da6
      color10 #46c880
      color11 #2dc7c4
      color12 #8cb6ff
      color13 #c8a5ff
      color14 #52bdff
      color15 #e4e4e5

      # extended colors
      color16 #3ddbd9
      color17 #ff7eb6
    '';

  };
}
