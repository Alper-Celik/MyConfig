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

      "kwin"."Grid View" = "Meta+Tab";

      "kwin"."Switch One Desktop Down" = [
        "Ctrl+Alt+Down"
        "Ctrl+Alt+S"
      ];
      "kwin"."Switch One Desktop Up" = [
        "Ctrl+Alt+W"
        "Ctrl+Alt+Up"
      ];
      "kwin"."Switch One Desktop to the Left" = [
        "Ctrl+Alt+A"
        "Ctrl+Alt+Left"
      ];
      "kwin"."Switch One Desktop to the Right" = [
        "Ctrl+Alt+Right"
        "Ctrl+Alt+D"
      ];

      "kwin"."Window One Desktop Down" = [
        "Ctrl+Alt+Shift+S"
        "Ctrl+Alt+Shift+Down"
      ];
      "kwin"."Window One Desktop Up" = [
        "Ctrl+Alt+Shift+W"
        "Ctrl+Alt+Shift+Up"
      ];
      "kwin"."Window One Desktop to the Left" = [
        "Ctrl+Alt+Shift+A"
        "Ctrl+Alt+Shift+Left"
      ];
      "kwin"."Window One Desktop to the Right" = [
        "Ctrl+Alt+Shift+D"
        "Ctrl+Alt+Shift+Right"
      ];
    };
  };
}
