-- Rustledger's LSP replaces beancount-language-server for beancount files.
-- Prefer the server on PATH; fall back to the user-local install.
local rledger_lsp = vim.fn.exepath("rledger-lsp")
if rledger_lsp == "" then
  rledger_lsp = vim.fn.expand("~/.local/bin/rledger-lsp")
end

vim.lsp.config("rledger", {
  cmd = { rledger_lsp },
  filetypes = { "beancount" },
  root_markers = { "main.bean", ".git" },
})

vim.filetype.add({
  extension = {
    beancount = "beancount",
    bean = "beancount",
  },
})

vim.lsp.enable("rledger")
