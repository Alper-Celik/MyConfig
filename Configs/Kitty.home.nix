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
      # Kitty and the zellij server run unrestricted; the limiting happens in
      # zellij-pane-shell (default_shell), which wraps each pane in a
      # systemd-run scope at CPUWeight 10 so a runaway pane cannot starve the
      # desktop or sibling panes.
      shell = "zellij";
      # Background-only transparency (text stays opaque); niri's window rule
      # provides the blur behind it, matching zellij-terminal's opacity 0.9.
      # zellij's carbonfox theme paints pane bodies with an explicit bg
      # (#161616, selected #2a2a2a), which background_opacity does not affect,
      # so those colors are made transparent here explicitly.
      background_opacity = "0.9";
      transparent_background_colors = "#161616@0.9 #2a2a2a@0.9";
      # kitten @ over the tty DCS path cannot cross zellij (it does not
      # forward @kitty-cmd sequences), so expose a per-instance abstract
      # socket; kitty exports KITTY_LISTEN_ON and kitten @ picks it up
      # automatically inside panes. Requires allow_remote_control != no.
      listen_on = "unix:@kitty-{kitty_pid}";
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
