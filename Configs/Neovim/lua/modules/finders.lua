
local silent = { silent = true }
vim.keymap.set("n", "<Leader>ft", ":Telescope builtin include_extensions=true<cr>", silent)
vim.keymap.set("n", "<Leader>ff", ":Telescope find_files<cr>", silent)
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<cr>", silent)
vim.keymap.set("n", "<Leader>fs", ":Telescope treesitter<cr>", silent)




return {
    {
        "nvim-telescope/telescope.nvim", 
        branch = '0.1.x',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },

        init = function ()
            require("telescope").setup()
            require('telescope').load_extension('fzf')
        end
    }
}