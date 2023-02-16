{ inputs, lib, config, pkgs, specialArgs, ... }: {
  imports = [
    ./Git.nix
    ./Kitty.nix
    ./Neovim/Neovim.nix
    ./Fish/Fish.nix
    ./Kde/Kde.nix
  ];
}
