-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--turkish keyboard layout support
vim.keymap.set("n", "İ", "I", { remap = true })

-- line move remaps
vim.keymap.set({ "n", "i", "v" }, "<C-Up>", "<A-k>", { remap = true, desc = "Move up" })
vim.keymap.set({ "n", "i", "v" }, "<C-Down>", "<A-j>", { remap = true, desc = "Move down" })

-- Nvim's default <C-L> (clear hlsearch + multicursors) is the same keycode as
-- <C-l>, so LazyVim's "<C-w>l" (Go to Right Window) replaced it. Window nav
-- lives on <C-h/j/k> and Alt+hjkl, so give <C-l> its default back: same rhs as
-- |CTRL-L-default|, which also clears the multicursors.
local c_l_default = "<Cmd>nohlsearch<Bar>diffupdate<Bar>"
  .. "call nvim_buf_clear_namespace(0, nvim_create_namespace('nvim.multicursor'), 0, -1)"
  .. "<Bar>normal! <C-L><CR>"
vim.keymap.set("n", "<C-l>", c_l_default, { desc = "Clear hlsearch / Multicursors" })

-- tab Mappings
vim.keymap.set("n", "<leader><tab>>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab><Right>", "<cmd>tabnext<cr>", { desc = "Next Tab" })

vim.keymap.set("n", "<leader><tab><", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab><Left>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

--picker bindings
-- map("n", "<leader>fd", "<cmd>Telescope<cr>", {})

-- explorer mappings

-- ai generated
-- <A-e> toggles the neo-tree sidebar, <C-e> the floating window; see
-- config/explorer.lua. Each closes its own window when focused and switches to
-- it from the other position otherwise.
map("n", "<A-e>", function()
  require("config.explorer").toggle("left")
end, { desc = "Explorer (Sidebar)" })
map("n", "<C-e>", function()
  require("config.explorer").toggle("float")
end, { desc = "Explorer (Float)" })

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

vim.keymap.del("n", "<leader>gp")
