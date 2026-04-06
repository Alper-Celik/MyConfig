-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--turkish keyboard layout support
vim.keymap.set("n", "İ", "I", { remap = true })

-- line move remaps
vim.keymap.set({ "n", "i", "v" }, "<A-Up>", "<A-k>", { remap = true, desc = "Move up" })
vim.keymap.set({ "n", "i", "v" }, "<A-Down>", "<A-j>", { remap = true, desc = "Move down" })

-- tab Mappings
vim.keymap.set("n", "<leader><tab>>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab><Right>", "<cmd>tabnext<cr>", { desc = "Next Tab" })

vim.keymap.set("n", "<leader><tab><", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab><Left>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

--picker bindings
map("n", "<leader>fd", "<cmd>Telescope<cr>", {})

-- explorer mappings
local neotree_float = "<cmd>Neotree position=float<cr>"
map("n", "<leader>fe", neotree_float, {})
map("n", "<leader>e", neotree_float, {})
map("n", "<C-e>", "<cmd>Neotree toggle position=left<cr>", {})

-- Terminal Mappings
map("n", "<A-t>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
map("t", "<A-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

if vim.g.neovide then
  map("n", "<C-S-KPlus>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05
  end, {})
  map("n", "<C-S-KMinus>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05
  end, {})
  map({ "n", "i" }, "<C-S-V>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, {})
  map({ "v" }, "<C-S-C>", "y", {})
end
