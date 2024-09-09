local opts = { silent = true }
vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gr", --[[vim.lsp.buf.referenceas]] ":Telescope lsp_references<CR>", opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
vim.keymap.set("n", "<space>wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, opts)
vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<space>cc", vim.lsp.codelens.run, opts)
vim.keymap.set("n", "<space>f", function()
	vim.lsp.buf.format({ --[[ async = true  ]]
	})
end, opts)
