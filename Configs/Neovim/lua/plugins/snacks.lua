return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            -- Alt+h was window navigation (zellij/nvim splits) when this was
            -- set; the picker's toggle_hidden stays on Alt+ş.
            ["<a-h>"] = false,
            ["<a-ş>"] = { "toggle_hidden", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<a-h>"] = false,
            ["<a-ş>"] = "toggle_hidden",
          },
        },
      },
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true, ignored = true },
      },
    },
  },
}
