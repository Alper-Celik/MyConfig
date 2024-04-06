{ inputs, lib, config, pkgs, specialArgs, ... }: {
  programs.plasma = {
    enable = true;

    workspace.clickItemTo = "select";

    hotkeys.commands."launch-kitty" = {
      name = "Launch Kitty";
      key = "Alt+Shift+T";
      command = "kitty";
    };

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false; #disable indexing
      "kxkbrc"."Layout"."Options".value = "caps:escape_shifted_capslock"; # capslock to esc
    };
  };
}
