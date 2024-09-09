local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.diagnostics.deadnix,
		null_ls.builtins.diagnostics.cmake_lint,
		null_ls.builtins.diagnostics.fish,

		null_ls.builtins.code_actions.gitrebase,
		null_ls.builtins.code_actions.gitsigns,
	},
})
