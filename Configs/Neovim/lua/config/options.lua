--clipboard sync
vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true

-- global status bar
vim.opt.laststatus = 3

--line numbers
vim.opt.number = true;
vim.opt.relativenumber = true;

vim.cmd.colorscheme("carbonfox")

--remove preview window
vim.opt.completeopt:remove("preview")

--max 20 items at the same time in complete
vim.opt.pumheight = 20

--use whitespaces instead of tabs
vim.opt.expandtab = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.autoindent = true
vim.opt.smartindent = true


vim.opt.guifont = "JetBrains Mono:h10"

