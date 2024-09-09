      --format on save
      local format_group = vim.api.nvim_create_augroup("auto_format", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format()
        end,
        group = format_group,
      })