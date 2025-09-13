{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
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
    nixfmt-rfc-style
    codespell
    deadnix
    omnisharp-roslyn
    pkgs-stable.roslyn-ls # use stable to prevent dotnet 10 preview build failure
    nil

    lazygit
  ];
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    RZLS_ROOT_DIR = pkgs.rzls;
  };

  home.packages = language-tools ++ [
    pkgs-unstable.neovim
    pkgs.neovide
  ];

  xdg.configFile.nvim.source = outOfStrore ".";
  #xdg.configFile.nvim.source = ./.;

}
