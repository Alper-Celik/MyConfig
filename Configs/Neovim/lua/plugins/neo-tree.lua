-- ai generated
-- Migrated from the snacks explorer: <C-e> toggles this sidebar (see
-- lua/config/keymaps.lua), and file visibility matches the previous
-- snacks explorer opts (hidden = true, ignored = true).
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
