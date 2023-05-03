{
  inputs =
    {
      # Utulities
      ## for reload functionality and some plugins
      plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
      ## faster startup
      impatient-nvim = { url = "github:lewis6991/impatient.nvim"; flake = false; };
      ##comment
      comment-nvim = { url = "github:numToStr/Comment.nvim"; flake = false; };
      ##error and todo window
      trouble-nvim = { url = "github:folke/trouble.nvim"; flake = false; };
      todo-comments-nvim = { url = "github:folke/todo-comments.nvim"; flake = false; };
      ##icons 
      nvim-web-devicons = { url = "github:nvim-tree/nvim-web-devicons"; flake = false; };
      ## fuzzy search
      telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
      # telescope-fzf-native-nvim = {
      #   url = "github:nvim-telescope/telescope-fzf-native.nvim";
      #   flake = false;
      # }; # add from nixpkgs

      ## file explorer
      nvim-tree-lua = { url = "github:nvim-tree/nvim-tree.lua"; flake = false; };
      ## multi cursor
      vim-visual-multi = { url = "github:mg979/vim-visual-multi"; flake = false; };
      ## rainbow 
      nvim-ts-rainbow2 = { url = "gitlab:HiPhish/nvim-ts-rainbow2"; flake = false; };

      #flat sesion (like in git commit)
      flatten-nvim = { url = "github:willothy/flatten.nvim"; flake = false; };

      # ui costumization
      nightfox-nvim = { url = "github:EdenEast/nightfox.nvim"; flake = false; };
      lualine-nvim = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
      lualine-lsp-progress = { url = "github:arkav/lualine-lsp-progress"; flake = false; };

      dressing-nvim = { url = "github:stevearc/dressing.nvim"; flake = false; };

      noice-nvim = { url = "github:folke/noice.nvim"; flake = false; };
      nui-nvim = { url = "github:MunifTanjim/nui.nvim"; flake = false; };
      nvim-notify = { url = "github:rcarriga/nvim-notify"; flake = false; };

      # debugging support
      nvim-dap = { url = "github:mfussenegger/nvim-dap"; flake = false; };


      # language support
      nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
      null-ls-nvim = { url = "github:jose-elias-alvarez/null-ls.nvim"; flake = false; };
      clangd_extensions-nvim = { url = "sourcehut:~p00f/clangd_extensions.nvim"; flake = false; };
      rust-tools-nvim = { url = "github:simrat39/rust-tools.nvim"; flake = false; };
      haskell-tools-nvim = { url = "github:mrcjkb/haskell-tools.nvim/1.x.x"; flake = false; };

      iron-nvim = { url = "github:Vigemus/iron.nvim"; flake = false; };

      toggleterm-nvim = { url = "github:akinsho/toggleterm.nvim"; flake = false; };

      # completion
      nvim-cmp = {
        url = "github:hrsh7th/nvim-cmp";
        flake = false;
      };
      cmp-nvim-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
      cmp_luasnip = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };
      luasnip = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
      nvim-autopairs = { url = "github:windwp/nvim-autopairs"; flake = false; };


      # nvim in browser
      firenvim = { url = "github:glacambre/firenvim"; flake = false; };

    };
  outputs = inputs:
    let
      nvim-plugins = inputs;

    in
    {
      overlays.default = (final: prev: {
        otherNeovimPlugins = (builtins.mapAttrs
          (name: value: final.pkgs.vimUtils.buildVimPluginFrom2Nix
            {
              src = value;
              name = name;
            })
          nvim-plugins) // {
          telescope-fzf-native-nvim = final.pkgs.vimPlugins.telescope-fzf-native-nvim;
          treesitter = final.pkgs.vimPlugins.nvim-treesitter.withPlugins
            (p: with p;
            [
              bibtex
              latex

              bash
              fish
              lua
              vim
              nix
              haskell
              terraform

              regex
              markdown
              markdown_inline
              rst

              c
              cpp
              cmake
              make
              ninja
              c_sharp
              qmljs
              rust

              llvm
              cuda

              css
              scss
              html
              javascript
              jsdoc
              tsx
              typescript

              json
              toml
              yaml

              htmldjango
              dart
              sql

              diff
              git_rebase
              gitattributes
              gitcommit
              gitignore

              ruby
              go
              gomod
              julia
              kotlin
              java
              scala

              glsl
              hlsl
              wgsl
              wgsl_bevy

              capnp
              proto
              dockerfile

              dot
            ]);

        };
      });
    };
}
