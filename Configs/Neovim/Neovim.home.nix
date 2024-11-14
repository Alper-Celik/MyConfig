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
    gnumake
    tree-sitter
    nodePackages.nodejs

    ## lsp s
    sumneko-lua-language-server
    cmake-language-server
    # nixd
    nil
    basedpyright
    clang-tools # also formatter and static analysis
    bash-language-server
    nodePackages_latest.vscode-json-languageserver
    vscode-langservers-extracted
    taplo
    haskell-language-server
    haskellPackages.fast-tags
    haskellPackages.hoogle
    qt6.qtdeclarative
    jdt-language-server.out

    ## formatters and linters
    deadnix
    codespell
    nixfmt-rfc-style
    stylua
    python3Packages.autopep8
    cmake-format
    nodePackages.prettier

    ## debuggers
    gdb
    lldb
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
