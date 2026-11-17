-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ai generated: focus follows mouse inside nvim (split hover, no click)
-- <MouseMove> is a mapping pseudo-key (not an autocmd event), needs 'mousemoveevent'
vim.keymap.set("n", "<MouseMove>", function()
  local win = vim.fn.getmousepos().winid
  if win <= 0 or win == vim.api.nvim_get_current_win() then
    return
  end
  -- don't steal focus for floating windows (pickers etc.)
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return
  end
  vim.api.nvim_set_current_win(win)
end)

-- ai generated: editor buffers use the terminal background (transparent Normal/NormalNC);
-- floats, statusline and other UI keep their theme backgrounds
local terminal_bg_group = vim.api.nvim_create_augroup("terminal-background-buffers", { clear = true })
local function use_terminal_background()
  for _, name in ipairs({ "Normal", "NormalNC" }) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.bg = nil
    vim.api.nvim_set_hl(0, name, hl)
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { group = terminal_bg_group, callback = use_terminal_background })
use_terminal_background()
