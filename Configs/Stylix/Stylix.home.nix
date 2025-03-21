{ config, ... }: {
  imports = [ ./Stylix-generic.nix ];
  stylix.targets.neovim.enable = false;
  stylix.targets.vscode.enable = false;
  stylix.targets.kitty.enable = false;
  # HACK: load session variables from home manager
  xdg.configFile."plasma-workspace/env/hm-session-vars.sh".text = ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';
}
