--file explerer
require("nvim-tree").setup({
	git = {
		ignore = false,
	},
})

--terminal
require("toggleterm").setup({
	open_mapping = "<A-t>",
	start_in_insert = true,
	insert_mappings = true, -- whether or not the open mapping applies in insert mode
	terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
	shell = vim.o.shell,
	direction = "float",
})

--#region telescope
require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("ht") -- haskell tools

local silent = { silent = true }

vim.keymap.set("n", "ft", ":Telescope builtin include_extensions=true<cr>", silent)

vim.keymap.set("n", "ff", ":Telescope find_files<cr>", silent)
vim.keymap.set("n", "fg", ":Telescope live_grep<cr>", silent)

vim.keymap.set("n", "fs", ":Telescope treesitter<cr>", silent)

--#endregion
