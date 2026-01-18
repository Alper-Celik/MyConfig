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
    # Existing session variables
  };

  programs.fish = {
    shellAliases.avante = "nvim -c 'lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)'";
  };

  home.packages = language-tools ++ [
    pkgs-unstable.neovim
    pkgs.neovide
  ];

  xdg.configFile.nvim.source = outOfStrore ".";
  #xdg.configFile.nvim.source = ./.;

}
