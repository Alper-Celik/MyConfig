return {
  {
    "y2w8/neolij.nvim",
    event = "VeryLazy",
    -- vim_zellij_navigator = true opens the `nvim_hook` zellij pipe at startup
    -- and closes it on exit (zellij side: hiasr/vim-zellij-navigator wasm).
    opts = { vim_zellij_navigator = true },
    config = function(_, opts)
      require("neolij").setup(opts)

      -- neolij registers the VimLeavePre close-notify as a bare ex-command
      -- (`command = 'zellij pipe -n "nvim_hook" "close"'`), which always fails
      -- with E492 on exit. Re-register it as a shell job.
      for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "VimLeavePre", pattern = "*" })) do
        if au.command and au.command:match("nvim_hook") then
          vim.api.nvim_del_autocmd(au.id)
        end
      end
      vim.api.nvim_create_autocmd("VimLeavePre", {
        pattern = "*",
        callback = function()
          if vim.env.ZELLIJ then
            vim.fn.system('zellij pipe -n "nvim_hook" "close"')
          end
        end,
      })
    end,
    keys = {
      -- Window navigation. zellij's Alt+hjkl bind the vim-zellij-navigator
      -- wasm with move_mod "alt", which writes Alt+hjkl into nvim while nvim
      -- is the focused pane (it never moves focus itself in that case), hence
      -- the Alt maps. The edge case has to escape back to zellij: that is the
      -- second `true` argument of move_or_tab. Plain neolij.move() stops at
      -- the nvim edge and would make Alt+hjkl dead keys there.
      -- Tab movement is a plain zellij bind (Alt+Shift+...) and deliberately
      -- does not reach nvim: the wasm plugin carries only four distinguishable
      -- keys and keeps the config of its first message, so a second modifier
      -- variant cannot be routed reliably.
      {
        "<A-h>",
        function()
          require("neolij").move_or_tab("left", true)
        end,
        mode = { "n", "t" },
        desc = "Move left (nvim split/tab, else zellij pane/tab)",
        silent = true,
      },
      {
        "<A-j>",
        function()
          require("neolij").move_or_tab("down", true)
        end,
        mode = { "n", "t" },
        desc = "Move down (nvim split, else zellij pane)",
        silent = true,
      },
      {
        "<A-k>",
        function()
          require("neolij").move_or_tab("up", true)
        end,
        mode = { "n", "t" },
        desc = "Move up (nvim split, else zellij pane)",
        silent = true,
      },
      {
        "<A-l>",
        function()
          require("neolij").move_or_tab("right", true)
        end,
        mode = { "n", "t" },
        desc = "Move right (nvim split/tab, else zellij pane/tab)",
        silent = true,
      },

      -- Tab actions
      { "<leader>zt", "<cmd>NeolijNewTab<CR>", desc = "New Zellij Tab", silent = true },
      { "<leader>zr", "<cmd>NeolijRenameTab<CR>", desc = "Rename Zellij Tab", silent = true },
      { "<leader>zl", "<cmd>NeolijMoveTabLeft<CR>", desc = "Move Tab Left", silent = true },
      { "<leader>zL", "<cmd>NeolijMoveTabRight<CR>", desc = "Move Tab Right", silent = true },

      -- Pane actions
      { "<leader>zp", "<cmd>NeolijNewPane -d right<CR>", desc = "New Zellij Pane vertical", silent = true },
      { "<leader>zP", "<cmd>NeolijNewPane -d down<CR>", desc = "New Zellij Pane horizontal", silent = true },
      { "<leader>zf", "<cmd>NeolijNewPane -f<CR>", desc = "New Zellij Floating Pane", silent = true },
      { "<leader>zn", "<cmd>NeolijRenamePane<CR>", desc = "Rename Zellij Pane", silent = true },
      { "<leader>zu", "<cmd>NeolijMovePaneUp<CR>", desc = "Move Pane Up", silent = true },
      { "<leader>zd", "<cmd>NeolijMovePaneDown<CR>", desc = "Move Pane Down", silent = true },
      { "<leader>zh", "<cmd>NeolijMovePaneLeft<CR>", desc = "Move Pane Left", silent = true },
      { "<leader>zR", "<cmd>NeolijMovePaneRight<CR>", desc = "Move Pane Right", silent = true },
    },
  },
}
