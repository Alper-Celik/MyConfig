{
  # inspired by https://github.com/zmre/pwnvim/
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, neovim, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs
          {
            inherit system;
          });
      in
      {
        packages.default = pkgs.neovim.override
          {
            config = {
              customRC =
                ''
                  lua << EOF
                    package.path = "${self}/?.lua;" .. package.path
                ''
                + pkgs.lib.readFile ./init.lua
                + ''
                  EOF
                '';
            };
            packages.myVimPackage = with pkgs.vimPlugins; {
              # see examples below how to use custom packages
              start = [
                # Utulities
                ## for reload functionality and some plugins
                plenary-nvim
                ## faster startup
                impatient-nvim
                ## comment
                comment-nvim
                ## error window
                trouble-nvim
                ## todo window
                todo-comments-nvim
                ## icons
                nvim-web-devicons
                ## fuzzy search
                telescope-nvim
                telescope-fzf-native-nvim
                ## fancy ui
                dressing-nvim
                ## file explorer
                nvim-tree-lua
                ## multi cursor
                vim-visual-multi
                ## rainbow 
                nvim-ts-rainbow2

                # tree sitter
                nvim-treesitter.withAllGrammars

                # ui costumization
                nightfox-nvim
                lualine-nvim
                lualine-lsp-progress

                # debugging support
                nvim-dap

                # language support
                nvim-lspconfig
                null-ls-nvim
                clangd_extensions-nvim
                rust-tools-nvim
                toggleterm-nvim
                flutter-tools-nvim

                # completion
                nvim-cmp
                cmp-nvim-lsp
                cmp_luasnip
                luasnip
                nvim-autopairs

                # nvim in browser
                firenvim
              ];
              # If a Vim plugin has a dependency that is not explicitly listed in
              # opt that dependency will always be added to start to avoid confusion.
              opt = [ ];
            };

          };
      });
}
