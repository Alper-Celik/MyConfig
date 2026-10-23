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

-- Where focus goes once zellij itself has nowhere left to move, matching the
-- niri keybinds (Mod+H/L cross columns, Mod+J/K cross workspaces).
local niri_actions = {
  left = "focus-column-left",
  right = "focus-column-right",
  up = "focus-workspace-up",
  down = "focus-workspace-down",
}

-- Focused zellij pane id, or nil outside zellij / when the query fails. Pane
-- ids are session-unique, so an unchanged id after an action means the action
-- was a no-op: no pane (or tab, for left/right) that way.
-- ai generated
local function zellij_focused_pane()
  if not vim.env.ZELLIJ then
    return nil
  end
  local out = vim.fn.system({ "zellij", "action", "list-panes", "--state", "--json" })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local ok, panes = pcall(vim.json.decode, out)
  if not ok or type(panes) ~= "table" then
    return nil
  end
  for _, pane in ipairs(panes) do
    if pane.is_focused then
      return pane.id
    end
  end
  return nil
end

local function niri_focus(direction)
  if not vim.env.NIRI_SOCKET then
    return
  end
  vim.fn.system({ "niri", "msg", "action", niri_actions[direction] })
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
    -- zellij only treats left/right as focus moves in MoveFocusOrTab; it maps
    -- up/down to tab cycling (route.rs: Up => SwitchTabNext, Down =>
    -- SwitchTabPrev), so vertical escapes must use MoveFocus instead.
    local action = (direction == "up" or direction == "down") and "move-focus" or "move-focus-or-tab"
    local pane = zellij_focused_pane()
    require("neolij").zellij_action(action .. " " .. direction)
    -- zellij moved: another pane, or (left/right) the next/previous tab.
    if pane and zellij_focused_pane() == pane then
      niri_focus(direction)
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
      -- then hands off: left/right go to the nvim tab, then to the zellij pane
      -- or tab, while up/down only go to the zellij pane. When zellij has
      -- nowhere left to move, focus continues into niri.
      -- Tab movement is a plain zellij bind (Alt+Shift+...) and deliberately
      -- does not reach nvim: the wasm plugin carries only four distinguishable
      -- keys and keeps the config of its first message, so a second modifier
      -- variant cannot be routed reliably.
      {
        "<A-Left>",
        function()
          move("left")
        end,
        mode = { "n", "t" },
        desc = "Move left (nvim split, else previous tab/pane)",
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
