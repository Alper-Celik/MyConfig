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
      # shell = "zellij";
      # shell = "systemd-run --user --scope -p MemoryMax=90% -p TasksMax=1000 fish";
      shell_integration = "enabled";
      allow_remote_control = true;

      repaint_delay = 3; # 333,33333333333333 fps
      input_delay = 1;
    };
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = lib.mkForce "JetBrainsMono Nerd Font Mono";
      size = lib.mkForce 9;
    };

    extraConfig = ''
      map ctrl+shift+4 change_font_size current +2.0
      map ctrl+shift+equal change_font_size current +2.0
      map ctrl+shift+plus change_font_size current +2.0
      map ctrl+shift+kp_add change_font_size current +2.0

      map ctrl+shift+minus change_font_size current -2.0
      map ctrl+shift+kp_subtract change_font_size current -2.0
    '';

  };
}
