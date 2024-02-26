--remove preview window
vim.opt.completeopt:remove("preview")

--clipboard sync
vim.opt.clipboard:append("unnamedplus")

--max 20 items at the same time in complete
vim.opt.pumheight = 20

--use whitespaces instead of tabs
vim.opt.expandtab = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.autoindent = true
vim.opt.smartindent = true

--#region
vim.opt.guifont = "JetBrains Mono:h10"


return {}
