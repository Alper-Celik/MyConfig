return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            -- Alt+h is window navigation (zellij/nvim splits), so move the
            -- picker's toggle_hidden off it onto Alt+ş.
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
