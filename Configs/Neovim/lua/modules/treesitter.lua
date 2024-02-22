return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "bibtex",
          "latex",

          "bash",
          "fish",
          "lua",
          "vim",
          "nix",
          "haskell",
          "terraform",

          "regex",
          "markdown",
          "markdown_inline",
          "rst",

          "c",
          "cpp",
          "cmake",
          "make",
          "ninja",
          "c_sharp",
          "qmljs",
          "rust",

          "llvm",
          "cuda",

          "css",
          "scss",
          "html",
          "javascript",
          "jsdoc",
          "tsx",
          "typescript",

          "json",
          "toml",
          "yaml",

          "htmldjango",
          "dart",
          "sql",

          "diff",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",

          "ruby",
          "go",
          "gomod",
          "julia",
          "kotlin",
          "java",
          "scala",

          "glsl",
          "hlsl",
          "wgsl",
          "wgsl_bevy",

          "capnp",
          "proto",
          "dockerfile",

          "dot",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
