-- Window movement, with one exception: moving left never lands in the explorer
-- sidebar. It is always open on the left, so Alt+h would otherwise only ever
-- step back into it (or into its layout scaffolding); instead it falls through
-- to the tab behaviour of neolij.move_or_tab (previous nvim tab, else zellij
-- focus-or-tab). Other pickers (files, grep, ...) are ordinary windows and
-- stay valid targets, as do all other directions.
-- ai generated
local function is_explorer(win)
  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree"
end

local function move(direction)
  local vim_key = ({ left = "h", right = "l", up = "k", down = "j" })[direction]
  local from = vim.api.nvim_get_current_win()
  -- Leftwards there is no window step when the explorer is the source: it is
  -- the left edge, and wincmd h would otherwise wrap around into the editor.
  if not (direction == "left" and is_explorer(from)) then
    local before = vim.fn.winnr()
    vim.cmd("wincmd " .. vim_key)
    if vim.fn.winnr() ~= before then
      local target = vim.api.nvim_get_current_win()
      -- ai generated
      if direction ~= "left" or not (is_explorer(target) or is_explorer(from)) then
        return -- a real window in that direction
      end
      vim.api.nvim_set_current_win(from)
    end
  end
  local current, last = vim.fn.tabpagenr(), vim.fn.tabpagenr("$")
  if direction == "left" and current > 1 then
    vim.cmd("tabprevious")
  elseif direction == "right" and current < last then
    vim.cmd("tabnext")
  else
    require("neolij").zellij_action("move-focus-or-tab " .. direction)
  end
end

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
      -- the Alt maps; `move` above keeps the nvim-split step and, when no real
      -- window is left in that direction, switches tabs (nvim, then zellij).
      -- Tab movement is a plain zellij bind (Alt+Shift+...) and deliberately
      -- does not reach nvim: the wasm plugin carries only four distinguishable
      -- keys and keeps the config of its first message, so a second modifier
      -- variant cannot be routed reliably.
      {
        "<A-h>",
        function()
          move("left")
        end,
        mode = { "n", "t" },
        desc = "Move left (nvim split, else previous tab/pane)",
        silent = true,
      },
      {
        "<A-j>",
        function()
          move("down")
        end,
        mode = { "n", "t" },
        desc = "Move down (nvim split, else zellij pane)",
        silent = true,
      },
      {
        "<A-k>",
        function()
          move("up")
        end,
        mode = { "n", "t" },
        desc = "Move up (nvim split, else zellij pane)",
        silent = true,
      },
      {
        "<A-l>",
        function()
          move("right")
        end,
        mode = { "n", "t" },
        desc = "Move right (nvim split, else next tab/pane)",
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
