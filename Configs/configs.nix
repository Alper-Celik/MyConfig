{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
  imports = [
    ./Git.nix
    ./Kitty.nix
    ./Neovim/Neovim.nix
    ./Fish/Fish.nix
  ];
}
