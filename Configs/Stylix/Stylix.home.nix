{ config, lib, ... }:
{
  imports = [ ./Stylix-generic.nix ];
  stylix.targets.neovim.enable = false;
  stylix.targets.vscode.enable = false;
  stylix.targets.kitty.enable = false;
  stylix.targets.noctalia.enable = false;
  stylix.targets.kde.enable = !config.x-headless;
  # HACK: load session variables from home manager
  xdg.configFile."plasma-workspace/env/hm-session-vars.sh" = lib.mkIf (!config.x-headless) {
    text = ''
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
    '';
  };
}
