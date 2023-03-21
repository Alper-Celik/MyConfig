pcall(function()
	require("impatient")
end)

-- If opening from inside neovim terminal then do not load all the other plugins
if os.getenv("NVIM") ~= nil then
	require("lazy").setup({
		{ "willothy/flatten.nvim", config = true },
	})
	return
end

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
