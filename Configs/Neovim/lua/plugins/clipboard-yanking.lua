return {

  {
    "svermeulen/vim-cutlass",
    lazy = false,
    config = function()
      local map = vim.keymap.set
      map("n", "m", "d")
      map("x", "m", "d")
      map("n", "mm", "dd")
      map("n", "M", "D")
    end,
  },
}
