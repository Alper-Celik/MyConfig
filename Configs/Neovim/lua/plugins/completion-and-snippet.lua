if not vim.g.vscode then
	return {
		-- completion
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			branch = "canary",
			dependencies = {
				{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {},
		},
		{
			"zbirenbaum/copilot.lua", -- i have free copilot since i am student yay
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
					suggestion = {
						auto_trigger = true,
						hide_during_completion = false,
					},
				})
				-- copilot bindings
				vim.cmd("Copilot disable") -- disable copilot by default
				vim.keymap.set("n", "<Leader>cc", ":Copilot panel<CR>", silent)
				vim.keymap.set("n", "<Leader>ce", ":Copilot enable<CR>", silent)
				vim.keymap.set("n", "<Leader>cd", ":Copilot disable<CR>", silent)
				vim.keymap.set("n", "<Leader>cs", ":Copilot status<CR>", silent)
			end,
		},
		"mfussenegger/nvim-jdtls",
		"neovim/nvim-lspconfig",
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"saadparwaiz1/cmp_luasnip",
				"L3MON4D3/LuaSnip",
			},
			priority = 50 + 1,
			config = function()
				local luasnip = require("luasnip")

				local cmp = require("cmp")
				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-d>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<CR>"] = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						}),
						["<Tab>"] = function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end,
						["<S-Tab>"] = function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end,
					}),
					sources = {
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
					},
					view = {
						entries = "custom",
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					formatting = {
						format = function(_, vim_item)
							--from https://github.com/hrsh7th/nvim-cmp/issues/980#issuecomment-1121773499
							local MAX_LABEL_WIDTH = 50
							local MIN_LABEL_WIDTH = 50
							local ELLIPSIS_CHAR = " "
							local label = vim_item.abbr
							local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
							if truncated_label ~= label then
								vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
							elseif string.len(label) < MIN_LABEL_WIDTH then
								local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
								vim_item.abbr = label .. padding
							end
							return vim_item
						end,
					},
				})
			end,
		},
	}
end
return {}
