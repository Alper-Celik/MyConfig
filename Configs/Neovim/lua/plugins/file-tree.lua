return {
	-- {
	-- 	"echasnovski/mini.files",
	-- 	version = "*",
	-- 	opts = {
	-- 		mappings = {
	-- 			close = "<C-e>",
	-- 			reset = "<ESC>",
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("mini.files").setup(opts)
	-- 		--
	-- 		-- file tree bindings
	-- 		vim.keymap.set("n", "<C-e>", MiniFiles.open, silent)
	-- 		local function go_in_plus()
	-- 			MiniFiles.go_in({ close_on_file = true })
	-- 		end
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "MiniFilesBufferCreate",
	-- 			callback = function(args)
	-- 				local buf_id = args.data.buf_id
	-- 				local keymap_args = { silent = true, buffer = buf_id }
	--
	-- 				vim.keymap.set("n", "<C-e>", MiniFiles.close, keymap_args)
	-- 				vim.keymap.set("n", "<CR>", go_in_plus, keymap_args)
	-- 				vim.keymap.set("n", "<BS>", MiniFiles.go_out, keymap_args)
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				git = {
					ignore = false,
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					api.config.mappings.default_on_attach(bufnr)
					-- Mappings migrated from view.mappings.list
					--
					-- You will need to insert "your code goes here" for any mappings with a custom action_cb
					vim.keymap.set("n", "<C-E>", api.tree.close, opts("Close"))
					vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
					vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
					vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse"))
				end,
			})

			vim.keymap.set("n", "<C-e>", ":NvimTreeFindFile<CR>", silent)
			vim.keymap.set("n", "<C-f>", ":NvimTreeToggle<CR>", silent)
		end,
	},
}
