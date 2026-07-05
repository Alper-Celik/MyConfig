vim.lsp.config("beancount", {
  commands = { "beancount-language-server", "--stdio" },
  root_markers = { "main.bean", ".git" },
  -- init_options are optional
  init_options = {
    -- Optional: Only needed for multi-file projects with include directives
    journal_file = vim.fn.getcwd() .. "/main.bean",
    -- Optional: flags that generate warnings (default: ["!"])
    diagnostic_flags = { "!" },
    -- Optional: completion behavior
    -- completion = {
    -- fuzzy_match_accounts = true, -- cross-segment fuzzy matching (default: false)
    -- },
  },
  settings = {
    -- beancount = {
    --   formatting = {
    -- prefix_width = 30,
    -- currency_column = 60,
    --   number_currency_spacing = 1,
    -- },
    -- },
  },
})

vim.filetype.add({
  extension = {
    beancount = "beancount",
    bean = "beancount",
  },
})

vim.lsp.enable("beancount")
