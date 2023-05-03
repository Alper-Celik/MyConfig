local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = require((...) .. ".keybindings")

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = { "cmake" },
	},
	-- extensions
	rainbow = {
		enable = true,
		-- Which query to use for finding delimiters
		query = "rainbow-parens",
		-- Highlight the entire buffer all at once
		strategy = require("ts-rainbow.strategy.global"),
		-- Do not enable for files with more than n lines
		max_file_lines = 3000,
	},
})

-- Haskell
local ht = require("haskell-tools")
local def_opts = { noremap = true, silent = true }
ht.setup({
	hls = {
		on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts)
			vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)
		end,
	},
	-- repl = { handler = "toggleterm" },
})
--C++/c
require("clangd_extensions").setup({
	server = {
		on_attach = on_attach,
		capabilities = lsp_capabilities,
		cmd = { "clangd", "--header-insertion=never" },
	},
})

require("rust-tools").setup({ server = { on_attach = on_attach, capabilities = lsp_capabilities } })

--#region lua
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
--#endregion
--generic

local language_servers =
	{ "cmake", "jsonls", "pyright", "bashls", "texlab", "eslint", "html", "cssls", "nil_ls", "qmlls", "taplo" }

for _, value in pairs(language_servers) do
	require("lspconfig")[value].setup({ capabilities = lsp_capabilities, on_attach = on_attach })
end

--nullls

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.autopep8,
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.nixpkgs_fmt,
		require("null-ls").builtins.formatting.prettier,
		-- require("null-ls").builtins.diagnostics.cspell,
		-- require("null-ls").builtins.code_actions.cspell,
	},
})

--latex
vim.g["tex_flavor"] = "latex"

-- [[Snippets]]
local luasnip = require("luasnip")

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
	view = {
		entries = "custom",
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		format = function(_, vim_item)
			--from https://github.com/hrsh7th/nvim-cmp/issues/980#issuecomment-1121773499
			local MAX_LABEL_WIDTH = 50
			local MIN_LABEL_WIDTH = 50
			local ELLIPSIS_CHAR = " "
			local label = vim_item.abbr
			local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
			if truncated_label ~= label then
				vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
			elseif string.len(label) < MIN_LABEL_WIDTH then
				local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
				vim_item.abbr = label .. padding
			end
			return vim_item
		end,
	},
})

-- Repl
local iron = require("iron.core")
iron.setup({
	config = {
		repl_definition = {
			haskell = {
				command = function(meta)
					local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
					-- call `require` in case iron is set up before haskell-tools
					return require("haskell-tools").repl.mk_repl_cmd(file)
				end,
			},
		},
		repl_open_cmd = require("iron.view").split.vertical.botright(0.4),
	},
	keymaps = {
		visual_send = "<space>sc",
		send_file = "<space>sf",
		send_line = "<space>sl",
		exit = "<space>sq",
		clear = "<space>cl",
	},
	-- If the highlight is on, you can change how it looks
	-- For the available options, check nvim_set_hl
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})
vim.keymap.set("n", "<space>rr", "<cmd>IronRepl<cr>")
vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")

-- [[Commenting]]
require("Comment").setup()
