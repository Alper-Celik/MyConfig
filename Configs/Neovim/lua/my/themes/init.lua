-- -- For dark theme
-- vim.g.vscode_style = "dark"
-- -- Enable transparent background
-- vim.g.vscode_transparent = 1
-- -- Enable italic comment
-- vim.g.vscode_italic_comment = 1
-- -- Disable nvim-tree background color
-- vim.g.vscode_disable_nvimtree_bg = true
-- vim.cmd("colorscheme vscode")
-- vim.opt.background = "dark" -- set this to dark or light

vim.opt.termguicolors = true

-- from https://github.com/folke/noice.nvim
require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

vim.cmd.colorscheme("carbonfox")
local my_filename = {
	"filename",
	file_status = true,
	path = 1,
}
require("lualine").setup({
	sections = {
		lualine_c = {
			my_filename,
			-- "lsp_progress", // served by noice
		},
		lualine_x = {
			"encoding",
			{
				"fileformat",
				icons_enabled = true,
				symbols = {
					unix = "LF",
					dos = "CRLF",
					mac = "CR",
				},
			},
			"filetype",
		},
	},
	tabline = {
		lualine_a = { "tabs" },

		-- lualine_y = { "buffers" },
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { my_filename },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},

	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { my_filename },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})
vim.opt.laststatus = 3
