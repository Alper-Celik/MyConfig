{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
  imports = [ ./Git/git.nix ];
  xdg.configFile = {
    "nvim" = {
      source = ./Neovim;
      # inputs = specialArgs.inputs;
    };
  };
}
