{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
  programs.plasma = {
    enable = true;

    workspace.clickItemTo = "select";

    shortcuts = {
      "kitty.desktop"._launch = "Ctrl+Alt+T";

    };
    files = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false; #disable indexing
      "kxkbrc"."Layout"."Options" = "caps:escape_shifted_capslock"; # capslock to esc
    };
  };
}
