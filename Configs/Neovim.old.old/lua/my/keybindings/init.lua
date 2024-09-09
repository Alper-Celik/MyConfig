--#region
local opts = { silent = true }

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local silent = { silent = true }

--#endregion

--turkish keyboard layout support
vim.keymap.set("n", "İ", "I", { remap = true })

-- ctrl space for complatition
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", {})

--switch to nornal mode in terminal using escape
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-N>", {})

--ctrl e for opening file browser
vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>", silent)

--#region tab bindings
vim.keymap.set("n", "<C-Tab>", ":tabnext<CR>", silent)
vim.keymap.set("n", "<C-S-Tab>", ":tabprevious<CR>", silent)

vim.keymap.set("n", "<C-s>l", ":tabnext<CR>", silent)
vim.keymap.set("n", "<C-s>h", ":tabprevious<CR>", silent)

vim.keymap.set("n", "<C-s><C-s>", ":tabnext<CR>", silent)
vim.keymap.set("n", "<C-s>t", ":tabnew<CR>", silent)
vim.keymap.set("n", "<C-s>w", ":tabclose<CR>", silent)
--#endregion

vim.keymap.set("n", "<esc>", ":noh<CR>", silent)

require((...) .. ".plugin_bindings")
require((...) .. ".lsp_bindings")
