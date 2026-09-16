-- ai generated
-- neo-tree explorer toggle, shared by <A-e> (sidebar) and <C-e> (floating
-- window) in config/keymaps.lua. neo-tree keeps one window per source per tab,
-- so opening one position replaces the other rather than showing both.

local M = {}

local SOURCE = "filesystem"

---The neo-tree window currently showing at `position`, if any. neo-tree marks
---every tree buffer with `neo_tree_position` (set in its renderer), and
---`is_explorer` in plugins/neolij.lua keys off the same filetype.
---@param position "left"|"float"
---@return integer? winid
local function window_at(position)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "neo-tree" and vim.b[buf].neo_tree_position == position then
      return win
    end
  end
end

---Toggle the explorer at `position`: close it when it is focused, focus it
---when it is open elsewhere, open it when it is not showing at all. neo-tree
---floats close themselves when focus leaves, so <C-e> is effectively
---open/close; the focus branch is what the sidebar relies on.
---@param position "left"|"float"
function M.toggle(position)
  local win = window_at(position)
  if win then
    if vim.api.nvim_get_current_win() == win then
      require("neo-tree.command").execute({ action = "close", source = SOURCE })
    else
      vim.api.nvim_set_current_win(win)
    end
  else
    require("neo-tree.command").execute({ source = SOURCE, position = position })
  end
end

return M
