{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  neovim-nightly,
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
    nodejs
    fzf
    ripgrep
    fd
    curl
    cargo
    rust-analyzer
    rustfmt

    golangci-lint
    gopls
    go

    lsof

    clang-tools
    nixfmt
    codespell
    deadnix
    roslyn-ls
    netcoredbg
    nixd
    nil
    kdePackages.qtdeclarative
    cmake-language-server
    beancount-language-server
    beancount
    beanquery
    beanprice
    fava

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
    neovim-nightly
    pkgs.neovide
  ];

  xdg.configFile.nvim.source = outOfStrore ".";
  #xdg.configFile.nvim.source = ./.;

}
