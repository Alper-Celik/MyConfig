return {
	"mfussenegger/nvim-dap",
	"theHamsta/nvim-dap-virtual-text",
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{
		"SGauvin/ctest-telescope.nvim",
		opts = {
			build_folder = "build",
			dap_config = {
				-- stopAtEntry = true,
				type = "gdb",
			},
		},
	},
}
