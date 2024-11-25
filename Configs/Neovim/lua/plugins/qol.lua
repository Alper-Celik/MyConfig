return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		cond = not vim.g.vscode,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"numToStr/Comment.nvim",
		cond = not vim.g.vscode,
		opts = {
			-- add any options here
		},
		lazy = false,
	},

	{ "mg979/vim-visual-multi", cond = not vim.g.vscode },

	{
		"windwp/nvim-autopairs",
		cond = not vim.g.vscode,
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
}
