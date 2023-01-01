local set = vim.opt

--mouse support
-- set.mouse = "a"

--no wrap
-- set.wrap = false

--line numbers
set.number = true
set.relativenumber = true

--no line numbers in terminal
local my_group = vim.api.nvim_create_augroup("no_term_line_number_group", { clear = true })

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
  group = my_group,
})

--format on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format()
    vim.cmd([[
   TSBufToggle rainbow 
   TSBufToggle rainbow 
    ]])
  end,
  group = my_group,
})

--remove preview window
set.completeopt:remove("preview")

--clipboard sync
set.clipboard:append("unnamedplus")

--max 20 items at the same time in complete
set.pumheight = 20

--use whitespaces instead of tabs
set.expandtab = true

set.shiftwidth = 2
set.tabstop = 2

set.autoindent = true
set.smartindent = true

--#region
set.guifont = "JetBrains Mono:h10"

set.shell = "/usr/bin/env fish"
