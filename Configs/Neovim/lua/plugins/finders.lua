return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

		config = function()
			require("telescope").setup()
			require("telescope").load_extension("fzf")
			-- telescope bindings
			vim.keymap.set("n", "<Leader>ft", ":Telescope builtin include_extensions=true<cr>", silent)
			vim.keymap.set("n", "<Leader>ff", ":Telescope find_files<cr>", silent)
			vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<cr>", silent)
			vim.keymap.set("n", "<Leader>fs", ":Telescope treesitter<cr>", silent)
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		config = function()
			-- trouble bindings
			vim.keymap.set("n", "<leader>xx", ":TroubleToggle<cr>", silent)
			vim.keymap.set("n", "<leader>xw", ":TroubleToggle workspace_diagnostics<cr>", silent)
			vim.keymap.set("n", "<leader>xd", ":TroubleToggle document_diagnostics<cr>", silent)
			vim.keymap.set("n", "<leader>xq", ":TroubleToggle quickfix", silent)
			vim.keymap.set("n", "<leader>xl", ":TroubleToggle loclist", silent)
			vim.keymap.set("n", "<leader>xt", ":TodoTrouble<CR>", silent)
		end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
