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
      # Every terminal window is its own cgroup at half the weight of the rest
      # of the session, so an editor, an LSP or a build inside it cannot starve
      # the compositor. Builds inside it are further niced down by lowprio.
      shell = "systemd-run --user --scope -p MemoryMax=90% -p TasksMax=1000 -p CPUWeight=50 -p IOWeight=50 zellij";
      shell_integration = "enabled";
      allow_remote_control = true;

      # repaint_delay = 3; # 333,33333333333333 fps
      input_delay = 1;
    };
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = lib.mkForce "JetBrainsMono Nerd Font Mono";
      size = lib.mkForce 9;
    };

    extraConfig = ''


      # Font size. On the Turkish-Q layout '+' is Shift+4 and '=' is Shift+0, so bind the
      # shifted symbols (kitty matches them via its shifted-key fallback) and the unshifted
      # '-' as well. ctrl+shift+equal would need a layout where '=' is unshifted.
      map ctrl+plus change_font_size current +2.0
      map ctrl+shift+plus change_font_size current +2.0
      map ctrl+shift+4 change_font_size current +2.0
      map ctrl+shift+kp_add change_font_size current +2.0

      map ctrl+minus change_font_size current -2.0
      map ctrl+shift+minus change_font_size current -2.0
      map ctrl+shift+kp_subtract change_font_size current -2.0

      map ctrl+shift+backspace change_font_size current 0.0

    '';

  };
}
