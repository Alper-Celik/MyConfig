-- Window movement, with one exception: moving left never lands in the explorer
-- sidebar. It is always open on the left, so Alt+Left would otherwise only ever
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
  -- Tab switching is disabled on Alt+arrows: focus crossing panes stops at
  -- the zellij edge (plain move-focus never cycles tabs, unlike
  -- move-focus-or-tab).
  require("neolij").zellij_action("move-focus " .. direction)
end

-- Entry snap: right after a zellij move_focus lands in this nvim pane, the
-- navigator wasm sends Alt+Shift+arrow naming the shared edge (opposite of
-- the move direction), so focus continues from the border instead of
-- wherever nvim last had it. wincmd t/b is a one-shot edge jump with no
-- fall-through into tabs or zellij.
-- ai generated
local function snap(direction)
  -- The explorer is always open on the left: snapping left must not
  -- disappear into it, stop one short instead.
  for _ = 1, 20 do
    local before = vim.fn.winnr()
    vim.cmd("wincmd " .. ({ left = "h", right = "l", up = "k", down = "j" })[direction])
    local after = vim.fn.winnr()
    if after == before then
      return -- reached the edge
    end
    if direction == "left" and is_explorer(vim.api.nvim_get_current_win()) then
      vim.cmd("wincmd l")
      return
    end
  end
end

return {
  {
    "y2w8/neolij.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      -- Window navigation on Alt+arrows. zellij's arrow binds hand the key to
      -- the vim-zellij-navigator wasm, which writes the arrow sequence into
      -- nvim while nvim is the focused pane (it never moves focus itself in
      -- that case), hence the Alt maps; `move` above keeps the nvim-split step,
      -- then hands off to the zellij pane. Tab switching is deliberately not
      -- on Alt+arrows anywhere.
      {
        "<A-Left>",
        function()
          move("left")
        end,
        mode = { "n", "t" },
        desc = "Move left (nvim split, else zellij pane)",
        silent = true,
      },
      {
        "<A-Down>",
        function()
          move("down")
        end,
        mode = { "n", "t" },
        desc = "Move down (nvim split, else zellij pane)",
        silent = true,
      },
      {
        "<A-Up>",
        function()
          move("up")
        end,
        mode = { "n", "t" },
        desc = "Move up (nvim split, else zellij pane)",
        silent = true,
      },
      {
        "<A-Right>",
        function()
          move("right")
        end,
        mode = { "n", "t" },
        desc = "Move right (nvim split, else zellij pane)",
        silent = true,
      },

      -- Entry snap from the navigator wasm (see `snap` above).
      {
        "<A-S-Right>",
        function()
          snap("right")
        end,
        mode = { "n", "t" },
        desc = "Snap to rightmost window (zellij entry)",
        silent = true,
      },
      {
        "<A-S-Left>",
        function()
          snap("left")
        end,
        mode = { "n", "t" },
        desc = "Snap to leftmost window (zellij entry)",
        silent = true,
      },
      {
        "<A-S-Up>",
        function()
          snap("up")
        end,
        mode = { "n", "t" },
        desc = "Snap to topmost window (zellij entry)",
        silent = true,
      },
      {
        "<A-S-Down>",
        function()
          snap("down")
        end,
        mode = { "n", "t" },
        desc = "Snap to bottommost window (zellij entry)",
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
