return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    lazy = false,
    config = function(_, opts)
      require("roslyn").setup(opts)
      -- local rzls_base_path = vim.env.RZLS_ROOT_DIR
      vim.lsp.config("roslyn", {
        -- cmd = {
        --   "Microsoft.CodeAnalysis.LanguageServer",
        --   "--logLevel=Information",
        --   "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        --   "--stdio",
        --   "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_base_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        --   "--razorDesignTimePath="
        --     .. vim.fs.joinpath(rzls_base_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        -- },
        settings = {
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },
  {
    "Issafalcon/neotest-dotnet",
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      if not dap.adapters["netcoredbg"] then
        require("dap").adapters["netcoredbg"] = {
          type = "executable",
          command = vim.fn.exepath("netcoredbg"),
          args = { "--interpreter=vscode" },
          options = {
            detached = false,
          },
        }
      end
      for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch file",
              request = "launch",
              ---@diagnostic disable-next-line: redundant-parameter
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = {
      adapters = {
        ["neotest-dotnet"] = {
          -- Here we can set options for neotest-dotnet
        },
      },
    },
  },
}
