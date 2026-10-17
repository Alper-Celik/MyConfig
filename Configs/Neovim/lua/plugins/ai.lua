-- agentic.nvim as the ACP chat pane, with omp (oh-my-pi) as the agent.
--
-- Replaced avante.nvim: it re-renders the whole transcript and rewrites the whole chat
-- history JSON on every streamed chunk (~1s debounce), which freezes Neovim on long
-- sessions. agentic splices only the new text into the buffer and keeps its chat buffer
-- out of treesitter, so per-chunk cost stays O(new text).
--
-- agentic spawns the agent with the inherited environment plus `acp_providers.<name>.env`
-- (lib/acp/acp_transport.lua:104-117), so HOME/XDG reach the omp-sandboxed wrapper without
-- forwarding them by hand.
--
-- omp-sandboxed (`acp` subcommand keeps the client in charge of permissions) whitelists
-- $PWD inside the jail; agentic spawns the agent with Neovim's cwd == the ACP session cwd.
local omp = vim.fn.exepath("omp-sandboxed")
if omp == "" then omp = "omp-sandboxed" end

return {
  {
    "carlos-algms/agentic.nvim",
    opts = {
      provider = "omp",
      acp_providers = {
        omp = {
          name = "omp",
          command = omp,
          args = { "acp" },
        },
      },
      keymaps = {
        prompt = {
          -- Default submit is <C-s> in i/n/v, which zellij eats for Scroll mode. <C-CR>
          -- arrives intact via the kitty keyboard protocol (kitty -> zellij -> nvim).
          submit = {
            "<CR>",
            { "<C-CR>", mode = { "i", "n", "v" } },
          },
        },
      },
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>aa", function() require("agentic").toggle() end, desc = "Toggle Agentic chat" },
      { "<leader>an", function() require("agentic").new_session() end, desc = "New Agentic session" },
      {
        "<leader>as",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "x" },
        desc = "Add file/selection to context",
      },
      { "<leader>ar", function() require("agentic").restore_session() end, desc = "Restore Agentic session" },
      { "<leader>al", function() require("agentic").select_session() end, desc = "Select Agentic session" },
      { "<leader>ax", function() require("agentic").stop_generation() end, desc = "Stop generation" },
    },
  },

  -- The chat buffer registers the markdown parser for its `AgenticChat` filetype, so keep
  -- both markdown renderers out of it: each re-renders/re-parses the whole transcript
  -- instead of the edited tail.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      ignore = function(buf) return vim.bo[buf].filetype == "AgenticChat" end,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    optional = true,
    opts = {
      on_attach = function(buf) return vim.bo[buf].filetype ~= "AgenticChat" end,
    },
  },
}
