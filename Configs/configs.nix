{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
  imports = [
    ./Git/git.nix
    ./Kitty/kitty.nix
  ];
  xdg.configFile = {
    "nvim" = {
      source = ./Neovim;
    };
  };
}
