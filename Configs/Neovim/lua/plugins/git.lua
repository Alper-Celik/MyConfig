return {
  {
    "daliusd/ghlite.nvim",
    dependencies = { "lewis6991/async.nvim" },
    config = function()
      require("ghlite").setup({

        open_command = "xdg-open",
      })
    end,

    keys = {
      { "<leader>gps", ":GHLitePRList<cr>", silent = true, desc = "PR List" },
      -- { '<leader>us', ':GHLitePRSelect<cr>',        silent = true, desc = 'PR Select' },
      { "<leader>gpo", ":GHLitePRCheckout<cr>", silent = true, desc = "PR Checkout" },
      { "<leader>gpv", ":GHLitePRView<cr>", silent = true, desc = "PR View" },
      { "<leader>gpu", ":GHLitePRLoadComments<cr>", silent = true, desc = "PR Load Comments" },
      { "<leader>gpp", ":GHLitePRDiff<cr>", silent = true, desc = "PR Diff" },
      { "<leader>gpl", ":GHLitePRDiffview<cr>", silent = true, desc = "PR Diffview" },
      { "<leader>gpa", ":GHLitePRAddComment<cr>", silent = true, desc = "PR Add comment" },
      {
        "<leader>gpa",
        ":GHLitePRAddComment<cr>",
        mode = "x",
        silent = true,
        desc = "PR Add comment",
      },
      { "<leader>gpc", ":GHLitePRUpdateComment<cr>", silent = true, desc = "PR Update comment" },
      { "<leader>gpd", ":GHLitePRDeleteComment<cr>", silent = true, desc = "PR Delete comment" },
      { "<leader>gpr", ":GHLitePRResolveComment<cr>", silent = true, desc = "PR Resolve comment thread" },
      { "<leader>gpR", ":GHLitePRUnresolveComment<cr>", silent = true, desc = "PR Unresolve comment thread" },
      { "<leader>gpg", ":GHLitePROpenComment<cr>", silent = true, desc = "PR Open comment" },
    },
  },
}
