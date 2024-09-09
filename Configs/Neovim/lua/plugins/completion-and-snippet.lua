return {
	-- completion
	"mfussenegger/nvim-jdtls",
	"neovim/nvim-lspconfig",
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
