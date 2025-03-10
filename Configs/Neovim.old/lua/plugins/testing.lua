return {
	{
		"nvim-neotest/neotest",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",

			-- language specific runners
			"orjangj/neotest-ctest",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-ctest").setup({}),
				},
			})
			-- neotest bindings
			vim.keymap.set("n", "<Leader>nr", require("neotest").run.run, silent)
			vim.keymap.set("n", "<Leader>nf", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end, silent)
			vim.keymap.set("n", "<Leader>nw", function()
				require("neotest").run.run(vim.loop.cwd())
			end, silent)
			vim.keymap.set("n", "<Leader>nd", function() -- codespell:ignore nd
				require("neotest").run.run({ strategy = "dap" })
			end, silent)

			vim.keymap.set("n", "<Leader>nc", require("neotest").run.stop, silent)
		end,
	},
}
