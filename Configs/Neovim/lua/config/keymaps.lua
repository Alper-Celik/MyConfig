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

---- lsp and such
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

---- dap and such
vim.keymap.set("n", "<Leader>B", Dap.set_breakpoint)
vim.keymap.set("n", "<Leader>b", Dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>dbb", Dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>dbl", function()
	Dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dg", Dap.run_to_cursor)
vim.keymap.set("n", "<Leader>dr", Dap.repl.open)

-- Eval var under cursor
vim.keymap.set("n", "<Leader>d?", function()
	DapUi.eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F5>", function()
	if Dap.session() == nil and (vim.bo.filetype == "cpp" or vim.bo.filetype == "c") then
		-- Only call this on C++ and C files
		require("ctest-telescope").pick_test_and_debug()
	else
		Dap.continue()
	end
end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F10>", Dap.step_over)
vim.keymap.set("n", "<F11>", Dap.step_into)
vim.keymap.set("n", "<F12>", Dap.step_out)

vim.keymap.set("n", "<Leader>dl", function()
	Dap.run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)

-- copilot bindings
vim.cmd("Copilot disable") -- disable copilot by default
vim.keymap.set("n", "<Leader>cc", ":Copilot panel<CR>", silent)
vim.keymap.set("n", "<Leader>ce", ":Copilot enable<CR>", silent)
vim.keymap.set("n", "<Leader>cd", ":Copilot disable<CR>", silent)
vim.keymap.set("n", "<Leader>cs", ":Copilot status<CR>", silent)

-- neotest bindings
vim.keymap.set("n", "<Leader>nr", require("neotest").run.run, silent)
vim.keymap.set("n", "<Leader>nf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, silent)
vim.keymap.set("n", "<Leader>nw", function()
	require("neotest").run.run(vim.loop.cwd())
end, silent)
vim.keymap.set("n", "<Leader>nd", function() -- codespell:ignore nd
	require("neotest").run.run({ strategy = "dap" })
end, silent)

vim.keymap.set("n", "<Leader>nc", require("neotest").run.stop, silent)
