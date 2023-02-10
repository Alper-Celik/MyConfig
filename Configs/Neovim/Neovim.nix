{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    package = pkgs-u.neovim-unwrapped;
    plugins = with pkgs-u.vimPlugins ;[
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
  };
  home.packages = with pkgs;[
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
  ];
  xdg.configFile.nvim.source = ./.;
}
