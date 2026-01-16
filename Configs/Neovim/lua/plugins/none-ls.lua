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
        local function list_contains(list, element)
          for _, value in ipairs(list) do
            if value == element then
              return true
            end
          end
          return false
        end

        local to_filter = {
          nls.builtins.formatting.csharpier,
        }

        return not list_contains(to_filter, x)
      end, opts.sources)
    end,
  },
}
