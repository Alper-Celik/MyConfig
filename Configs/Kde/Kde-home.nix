{ inputs, lib, config, pkgs, specialArgs, ... }: {
  programs.plasma = {
    enable = true;

    workspace.clickItemTo = "select";

    shortcuts = {
      "kitty.desktop"._launch = "Ctrl+Alt+T";

    };
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false; #disable indexing
      "kxkbrc"."Layout"."Options".value = "caps:escape_shifted_capslock"; # capslock to esc
    };
  };
}
