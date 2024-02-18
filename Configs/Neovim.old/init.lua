local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.cmd([[packloadall]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- pcall(function()
--   require("impatient")
-- end)

require("my.plugins")

require("my.themes")

require("my.commands")
require("my.options")

require("my.keybindings")

require("my.language_support") --depends keybindings
require("my.debugging_support")

vim.cmd([[
if exists("g:neovide")
    let g:neovide_cursor_animation_length=0
endif
]])
