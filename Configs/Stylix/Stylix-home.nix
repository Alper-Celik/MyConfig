{ config, ... }:
{
  imports = [ ./Stylix-generic.nix ];
  stylix.targets.vim.enable = false;

  # HACK: load session variables from home manager
  xdg.configFile."plasma-workspace/env/hm-session-vars.sh".text = ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';
}
