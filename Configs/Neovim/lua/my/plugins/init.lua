require("lazy").setup({
  -- Utulities
  --# for reload functionality and some plugins
  "nvim-lua/plenary.nvim",
  --#comment
  "numToStr/Comment.nvim",
  --#error and todo window
  "folke/trouble.nvim",
  "folke/todo-comments.nvim",
  --#icons
  "nvim-tree/nvim-web-devicons",
  --# fuzzy search
  "nvim-telescope/telescope.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  --# file explorer
  "nvim-tree/nvim-tree.lua",
  --# multi cursor
  "mg979/vim-visual-multi",
  --# rainbow
  "https://gitlab.com/HiPhish/nvim-ts-rainbow2",

  --flat sesion (like in git commit)
  "willothy/flatten.nvim",

  -- ui costumization
  "EdenEast/nightfox.nvim",
  "nvim-lualine/lualine.nvim",
  "arkav/lualine-lsp-progress",

  "stevearc/dressing.nvim",

  "folke/noice.nvim",
  "MunifTanjim/nui.nvim",
  "rcarriga/nvim-notify",

  -- debugging support
  "mfussenegger/nvim-dap",

  -- language support
  "neovim/nvim-lspconfig",
  "jose-elias-alvarez/null-ls.nvim",
  "https://git.sr.ht/~p00f/clangd_extensions.nvim",
  "simrat39/rust-tools.nvim",
  { "mrcjkb/haskell-tools.nvim", branch = "1.x.x" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "Vigemus/iron.nvim",

  "akinsho/toggleterm.nvim",

  -- completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
  "windwp/nvim-autopairs",

  -- nvim in browser
  "glacambre/firenvim",
}, {
  performance = {
    reset_packpath = false,
    rtp = { reset = false },
  },
})

require("trouble").setup({})
require("todo-comments").setup({})
require("nvim-autopairs").setup({})
-- vim.fn["firenvim--install"](0)
