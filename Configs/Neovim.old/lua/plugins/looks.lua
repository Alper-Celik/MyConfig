return {
	{ "HiPhish/rainbow-delimiters.nvim", cond = not vim.g.vscode },

	{ "nvim-treesitter/nvim-treesitter-context", cond = not vim.g.vscode },

	{
		"stevearc/dressing.nvim",
		cond = not vim.g.vscode,
		opts = {
			input = { enabled = false },
		},
	},

	{
		"folke/noice.nvim",
		cond = not vim.g.vscode,
		event = "VeryLazy",
		opts = {
			-- add any options here
			lsp = {
				progress = {
					enabled = true,
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
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
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},

	"EdenEast/nightfox.nvim",

	{
		"nvim-lualine/lualine.nvim",
		cond = not vim.g.vscode,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			local my_filename = {
				"filename",
				file_status = true,
				path = 1,
			}

			return {
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
			}
		end,
	},
}
