return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = "<A-t>",
			start_in_insert = true,
			insert_mappings = true, -- whether or not the open mapping applies in insert mode
			terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
			shell = vim.o.shell,
			direction = "float",
		},
	},
}
