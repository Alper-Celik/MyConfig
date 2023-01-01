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
-- vim.cmd.colorscheme("carbonfox")
local my_filename = {
	"filename",
	file_status = true,
	path = 1,
}
require("lualine").setup({

	sections = {
		lualine_c = {
			my_filename,
			"lsp_progress",
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
