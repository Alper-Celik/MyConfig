--https://github.com/LazyVim/LazyVim/issues/6175#issuecomment-2981491701
return {
  {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          omnisharp = {
            mason = false,
            cmd = {
              "OmniSharp",
              "-z",
              "--hostPID",
              tostring(vim.fn.getpid()),
              "DotNet:enablePackageRestore=true",
              "--encoding",
              "utf-8",
              "--languageserver",
            },

            settings = {
              RoslynExtensionsOptions = {
                enableAnalyzersSupport = true,
              },
            },
          },
        },
      },
    },
  },
}
