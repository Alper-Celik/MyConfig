{
  inputs,
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}:
{
  home.packages = [ inputs.plasma-manager.packages.${pkgs.system}.rc2nix ];
  programs.plasma = {
    enable = true;

    workspace.clickItemTo = "select";

    hotkeys.commands."launch-kitty" = {
      name = "Launch Kitty";
      key = "Alt+Shift+T";
      command = "kitty";
    };

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false; # disable indexing
    };

    shortcuts = {

      "kwin"."Grid View" = "Meta+Tab,Meta+G,Toggle Grid View";

      "kwin"."Switch One Desktop Down" = [
        "Ctrl+Alt+Down"
        "Ctrl+Alt+S,Meta+Ctrl+Down,Switch One Desktop Down"
      ];
      "kwin"."Switch One Desktop Up" = [
        "Ctrl+Alt+W"
        "Ctrl+Alt+Up,Meta+Ctrl+Up,Switch One Desktop Up"
      ];
      "kwin"."Switch One Desktop to the Left" = [
        "Ctrl+Alt+A"
        "Ctrl+Alt+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"
      ];
      "kwin"."Switch One Desktop to the Right" = [
        "Ctrl+Alt+Right"
        "Ctrl+Alt+D,Meta+Ctrl+Right,Switch One Desktop to the Right"
      ];

      "kwin"."Window One Desktop Down" = [
        "Ctrl+Alt+Shift+S"
        "Ctrl+Alt+Shift+Down,Meta+Ctrl+Shift+Down,Window One Desktop Down"
      ];
      "kwin"."Window One Desktop Up" = [
        "Ctrl+Alt+Shift+W"
        "Ctrl+Alt+Shift+Up,Meta+Ctrl+Shift+Up,Window One Desktop Up"
      ];
      "kwin"."Window One Desktop to the Left" = [
        "Ctrl+Alt+Shift+A"
        "Ctrl+Alt+Shift+Left,Meta+Ctrl+Shift+Left,Window One Desktop to the Left"
      ];
      "kwin"."Window One Desktop to the Right" = [
        "Ctrl+Alt+Shift+D"
        "Ctrl+Alt+Shift+Right,Meta+Ctrl+Shift+Right,Window One Desktop to the Right"
      ];
    };
  };
}
