return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local opts = { silent = true }
      vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", --[[vim.lsp.buf.referenceas]] ":Telescope lsp_references<CR>", opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<Leader>lwa", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set("n", "<Leader>lwr", vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set("n", "<Leader>lwl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set("n", "<Leader>lD", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<Leader>lrn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<Leader>lca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<Leader>lcc", vim.lsp.codelens.run, opts)
      vim.keymap.set("n", "<Leader>lf", function()
        vim.lsp.buf.format({ --[[ async = true  ]]
        })
      end, opts)


      --format on save
      local format_group = vim.api.nvim_create_augroup("auto_format", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format()
        end,
        group = format_group,
      })

      --C++/c
      require("lspconfig").clangd.setup({
        server = {
          on_attach = on_attach,
          capabilities = lsp_capabilities,
          cmd = { "clangd", "--header-insertion=never" },
        },
      })

      -- nix
      require('lspconfig').nil_ls.setup {
        autostart = true,
        capabilities = lsp_capabilities,
        settings = {
          ['nil'] = {
            formatting = {
              command = { "nixpkgs-fmt" },
            },
          },
        },
      }

      -- generic servers
      local language_servers = {
        "cmake",
        "jsonls",
        "pyright",
        "bashls",
        "texlab",
        "eslint",
        "html",
        "cssls",
        "qmlls",
        "taplo",
        "gdscript",
      }

      for _, value in pairs(language_servers) do
        require("lspconfig")[value].setup({ capabilities = lsp_capabilities, on_attach = on_attach })
      end

      -- lua
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      require("lspconfig").lua_ls.setup({
        on_attach = on_attach,
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
              -- Setup your lua path
              path = runtime_path,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end
  },

}
