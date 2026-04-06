-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = true

-- first use git for rot dir detection
vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }

vim.g.lazyvim_picker = "telescope"

vim.lsp.enable("qmlls")
vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client.name == "qmlls" then
      vim.lsp.enable("qmlls")
    end
  end,
})

vim.lsp.enable("nixd")
