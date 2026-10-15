-- Avante's commands.lua now requires `mega.cmdparse` (a plain Lua module shipped as a
-- Neovim plugin). LazyVim's `ai.avante` extra predates it, so without these two the plugin
-- fails at VeryLazy with `module 'mega.cmdparse' not found`. Upstream's lazy.nvim snippet
-- declares exactly this pair; lazy's `rocks` machinery does not cover it (LazyVim sets
-- `build = "make"`, not `"rockspec"`).
--
-- omp (oh-my-pi) as an Avante ACP provider, launched through the firejail wrapper.
--
-- Avante spawns the ACP agent with a *replaced* environment (see ACPClient:connect in
-- avante/libs/acp_client.lua: final_env starts from PATH and is then overridden by the
-- provider's `env`). HOME therefore has to be forwarded explicitly, otherwise omp cannot
-- find ~/.omp and the omp-sandboxed wrapper cannot locate its secrets.
--
-- omp-sandboxed (`acp` subcommand keeps the client in charge of permissions) whitelists
-- $PWD inside the jail, which is Neovim's cwd == the ACP session cwd.
local omp = vim.fn.exepath("omp-sandboxed")
if omp == "" then omp = "omp-sandboxed" end

return {
  {
    "yetone/avante.nvim",
    dependencies = {
      -- `mega.cmdparse` requires `mega.logging`; keep the nesting so lazy orders them.
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
    },
    opts = {
      provider = "omp",
      acp_providers = {
        ["omp"] = {
          command = omp,
          args = { "acp" },
          env = {
            HOME = vim.fn.getenv("HOME"),
          },
        },
      },
    },
  },
}
