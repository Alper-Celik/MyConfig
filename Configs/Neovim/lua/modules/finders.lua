local silent = { silent = true }
vim.keymap.set("n", "<Leader>ft", ":Telescope builtin include_extensions=true<cr>", silent)
vim.keymap.set("n", "<Leader>ff", ":Telescope find_files<cr>", silent)
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<cr>", silent)
vim.keymap.set("n", "<Leader>fs", ":Telescope treesitter<cr>", silent)


vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)

vim.keymap.set("n", "<leader>xt", ":TodoTrouble<CR>", silent)


vim.keymap.set("n", "<C-e>", ":NvimTreeFindFile<CR>", silent)
vim.keymap.set("n", "<C-f>", ":NvimTreeToggle<CR>", silent)

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },

    config = function()
      require("telescope").setup()
      require('telescope').load_extension('fzf')
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup {
        git = {
          ignore = false,
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)
          -- Mappings migrated from view.mappings.list
          --
          -- You will need to insert "your code goes here" for any mappings with a custom action_cb
          vim.keymap.set("n", "<C-E>", api.tree.close, opts("Close"))
          vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
          vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse"))
        end,
      }
    end,
  }
}

