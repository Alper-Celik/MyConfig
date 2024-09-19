return {
	{
		"nvim-neotest/neotest",
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
		end,
	},
}
