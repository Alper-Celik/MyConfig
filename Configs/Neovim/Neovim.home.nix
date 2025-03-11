{
  inputs,
  lib,
  config,
  pkgs,
  my-lib,
  specialArgs,
  ...
}:
let
  current-dir = "Configs/Neovim";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);

  language-tools = with pkgs; [
    # tools for configration loading
    git
    gnutar
    gzip
    gcc
    vcpkg # most convenient place to put this
    conan
    cmake
    gnumake
    tree-sitter
    nodePackages.nodejs
    fzf
    ripgrep
    fd
    curl
    cargo

    clang-tools
  ];
in
{
  home.sessionVariables.EDITOR = "nvim";

  home.packages = language-tools ++ [
    pkgs.neovim
    pkgs.neovide
  ];

  xdg.configFile.nvim.source = outOfStrore ".";
  #xdg.configFile.nvim.source = ./.;

}
