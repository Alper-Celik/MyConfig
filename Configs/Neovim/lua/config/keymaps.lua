local silent = { silent = true }

vim.keymap.set("i", "<C-S-v>", '<ESC>l"+Pli')

--turkish keyboard layout support
vim.keymap.set("n", "İ", "I", { remap = true })

--switch to nornal mode in terminal using escape
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-N>", {})

-- press esc to disable search highlight
vim.keymap.set("n", "<esc>", ":noh<CR>", silent)

--#region tab bindings
if not vim.g.vscode then
	vim.api.nvim_create_user_command("Tabnext", "tabnext", {})
	vim.api.nvim_create_user_command("Tabprev", "tabprev", {})
end
vim.keymap.set("n", "<Leader>tl", ":Tabnext<CR>", silent)
vim.keymap.set("n", "<Leader>tt", ":Tabnext<CR>", silent)
vim.keymap.set("n", "<Leader>t<Right>", ":Tabnext<CR>", silent)

vim.keymap.set("n", "<Leader>th", ":Tabprev<CR>", silent)
vim.keymap.set("n", "<Leader>tT", ":Tabprev<CR>", silent)
vim.keymap.set("n", "<Leader>t<Left>", ":Tabprev<CR>", silent)

vim.keymap.set("n", "<Leader>tn", ":tabnew<CR>", silent)
vim.keymap.set("n", "<Leader>tc", ":tabclose<CR>", silent)
