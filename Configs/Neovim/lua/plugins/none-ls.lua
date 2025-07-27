return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.codespell,
        nls.builtins.diagnostics.deadnix,
        nls.builtins.diagnostics.cmake_lint,
        nls.builtins.formatting.nixfmt,
      })
      opts.sources = vim.tbl_filter(function(x)
        return x ~= nls.builtins.formatting.csharpier
      end, opts.sources)
    end,
  },
}
