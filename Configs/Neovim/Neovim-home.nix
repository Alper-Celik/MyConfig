{ inputs, lib, config, pkgs, my-lib, specialArgs, ... }:
let
  current-dir = "Configs/Neovim";
  outOfStrore = x: config.lib.file.mkOutOfStoreSymlink
    (my-lib.maybeOutOfStore specialArgs current-dir x);

  language-tools = with pkgs;
    [
      ## lsp s

      rnix-lsp
      sumneko-lua-language-server
      cmake-language-server
      # nil
      nixd
      nodePackages.pyright
      clang-tools # also formatter and static analysis
      nodePackages.bash-language-server
      nodePackages_latest.vscode-json-languageserver
      taplo
      haskell-language-server
      haskellPackages.fast-tags
      haskellPackages.hoogle

      ## formatters
      nodePackages.cspell
      nixpkgs-fmt
      stylua
      python310Packages.autopep8
      cmake-format
      nodePackages.prettier

    ];
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    package = pkgs.neovim-unwrapped;
    plugins = with pkgs.vimPlugins ;[
    ] ++ builtins.attrValues pkgs.otherNeovimPlugins;
  };
  home.packages = language-tools;

  xdg.configFile.nvim.source = outOfStrore ".";
}
