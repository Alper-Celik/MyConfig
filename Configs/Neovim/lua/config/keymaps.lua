local silent = { silent = true }

--turkish keyboard layout support
vim.keymap.set("n", "İ", "I", { remap = true })

--switch to nornal mode in terminal using escape
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-N>", {})

-- press esc to disable search highlight
vim.keymap.set("n", "<esc>", ":noh<CR>", silent)

--#region tab bindings
vim.keymap.set("n", "<Leader>tl", ":tabnext<CR>", silent)
vim.keymap.set("n", "<Leader>tt", ":tabnext<CR>", silent)
vim.keymap.set("n", "<Leader>t<Right>", ":tabnext<CR>", silent)

vim.keymap.set("n", "<Leader>th", ":tabprevious<CR>", silent)
vim.keymap.set("n", "<Leader>tT", ":tabprevious<CR>", silent)
vim.keymap.set("n", "<Leader>t<Left>", ":tabprevious<CR>", silent)

vim.keymap.set("n", "<Leader>tn", ":tabnew<CR>", silent)
vim.keymap.set("n", "<Leader>tc", ":tabclose<CR>", silent)

-- telescope bindings
vim.keymap.set("n", "<Leader>ft", ":Telescope builtin include_extensions=true<cr>", silent)
vim.keymap.set("n", "<Leader>ff", ":Telescope find_files<cr>", silent)
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<cr>", silent)
vim.keymap.set("n", "<Leader>fs", ":Telescope treesitter<cr>", silent)

-- trouble bindings
vim.keymap.set("n", "<leader>xx", ":TroubleToggle<cr>", silent)
vim.keymap.set("n", "<leader>xw", ":TroubleToggle workspace_diagnostics<cr>", silent)
vim.keymap.set("n", "<leader>xd", ":TroubleToggle document_diagnostics<cr>", silent)
vim.keymap.set("n", "<leader>xq", ":TroubleToggle quickfix", silent)
vim.keymap.set("n", "<leader>xl", ":TroubleToggle loclist", silent)
vim.keymap.set("n", "<leader>xt", ":TodoTrouble<CR>", silent)

-- file tree bindings
vim.keymap.set("n", "<C-e>", ":NvimTreeFindFile<CR>", silent)
vim.keymap.set("n", "<C-f>", ":NvimTreeToggle<CR>", silent)

-- lsp and such
vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, silent)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, silent)
vim.keymap.set("n", "gr", --[[vim.lsp.buf.referenceas]] ":Telescope lsp_references<CR>", silent)
vim.keymap.set("n", "K", vim.lsp.buf.hover, silent)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, silent)
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, silent)
vim.keymap.set("n", "<Leader>lwa", vim.lsp.buf.add_workspace_folder, silent)
vim.keymap.set("n", "<Leader>lwr", vim.lsp.buf.remove_workspace_folder, silent)
vim.keymap.set("n", "<Leader>lwl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, silent)
vim.keymap.set("n", "<Leader>lD", vim.lsp.buf.type_definition, silent)
vim.keymap.set("n", "<Leader>lrn", vim.lsp.buf.rename, silent)
vim.keymap.set("n", "<Leader>lca", vim.lsp.buf.code_action, silent)
vim.keymap.set("n", "<Leader>lcc", vim.lsp.codelens.run, silent)
vim.keymap.set("n", "<Leader>lf", function()
	require("conform").format({})
end, silent)
