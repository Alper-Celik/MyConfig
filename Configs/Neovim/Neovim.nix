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
    extraPackages = with pkgs;
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
  };
  xdg.configFile.nvim.source = ./.;
}
