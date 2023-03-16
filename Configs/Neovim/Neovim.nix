{ inputs, lib, config, pkgs, specialArgs, ... }:
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
  home.packages = with pkgs;
    [
      ## lsp s

      rnix-lsp
      sumneko-lua-language-server
      cmake-language-server
      nil
      nodePackages.pyright
      clang-tools # also formatter and static analysis
      nodePackages.bash-language-server
      taplo

      ## formatters
      nixpkgs-fmt
      stylua
      python310Packages.autopep8
      cmake-format
      nodePackages.prettier

    ];
  xdg.configFile.nvim.source = ./.;
}
