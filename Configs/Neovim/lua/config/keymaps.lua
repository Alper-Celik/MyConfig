-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--turkish keyboard layout support
vim.keymap.set("n", "İ", "I", { remap = true })

-- tab Mappings
vim.keymap.set("n", "<leader><tab>>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab><", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Terminal Mappings
map("n", "<A-t>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
map("t", "<A-te", "<cmd>close<cr>", { desc = "Hide Terminal" })
