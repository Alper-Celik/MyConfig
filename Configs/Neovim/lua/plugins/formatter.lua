return {
	"stevearc/conform.nvim",
	cond = not vim.g.vscode,
	opts = {
		formatters_by_ft = {
			nix = { "nixfmt" },
			lua = { "stylua" },
			python = { "autopep8" },
			cmake = { "cmake_format" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
