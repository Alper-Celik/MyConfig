local silent = { silent = true }


vim.opt.clipboard = "unnamedplus"

--turkish keyboard layout support
vim.keymap.set("n", "İ", "I", { remap = true })

--switch to nornal mode in terminal using escape
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-N>", {})

--#region tab bindings
vim.keymap.set("n", "<Leader>tl", ":tabnext<CR>", silent)
vim.keymap.set("n", "<Leader>tt", ":tabnext<CR>", silent)
vim.keymap.set("n", "<Leader>t<Right>", ":tabnext<CR>", silent)

vim.keymap.set("n", "<Leader>th", ":tabprevious<CR>", silent)
vim.keymap.set("n", "<Leader>tT", ":tabprevious<CR>", silent)
vim.keymap.set("n", "<Leader>t<Left>", ":tabprevious<CR>", silent)

vim.keymap.set("n", "<Leader>tn", ":tabnew<CR>", silent)
vim.keymap.set("n", "<Leader>tc", ":tabclose<CR>", silent)


return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },

  "mg979/vim-visual-multi",

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  }

}
