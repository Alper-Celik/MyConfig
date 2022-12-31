{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, ... }: {
  imports = [ ./Git/git.nix ];
  xdg.configFile = {
    "nvim" = ./Neovim;
  };
}
