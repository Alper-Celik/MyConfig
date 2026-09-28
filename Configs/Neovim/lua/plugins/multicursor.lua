-- nvim 0.13 built-in multicursor (|multicursor|) keys that LazyVim/its plugins take:
--   ]C  [C   textobjects "@class.outer" end-moves, created by LazyVim's config
--            from opts.move.keys (buffer-local, n/x/o modes)
--   g<C-a>   dial.nvim increment (extra: lazyvim.plugins.extras.editor.dial)
-- Release them here so the built-ins work: ]C/[C jump between cursors,
-- g CTRL-A numbers the cursors during a session. Unclaimed already:
-- Q, [count]Q, {Visual}Q, gQ, q=, CTRL-L, <C-LeftMouse>.
return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = function(_, opts)
      local keys = vim.tbl_get(opts, "move", "keys") or {}
      for _, method in ipairs({ "goto_next_end", "goto_previous_end" }) do
        if keys[method] then
          keys[method]["]C"] = nil
          keys[method]["[C"] = nil
        end
      end
    end,
  },
  {
    -- rhs = false removes a lazy.nvim key from the spec (lazy.core.handler.keys.resolve).
    -- dial keeps its smart augends on <C-a>/<C-x>; g<C-x> becomes Nvim's builtin
    -- decrement, so the g-variants stay a matched pair.
    "monaqa/dial.nvim",
    keys = {
      { "g<C-a>", false, mode = { "n", "x" } },
      { "g<C-x>", false, mode = { "n", "x" } },
    },
  },
}
