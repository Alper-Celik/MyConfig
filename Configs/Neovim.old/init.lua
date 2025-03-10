if vim.g.vscode then
	vim.keymap.set("", "<Space>", "<Nop>")
	vim.g.mapleader = " "
end
require("config.lazy")
require("config.sudo-write")
require("config.hacks")
require("config.options")

if not vim.g.vscode then
	require("config.lsp")
	require("config.linting")
	require("config.dap")
end
require("config.keymaps")

require("config.neovide")
