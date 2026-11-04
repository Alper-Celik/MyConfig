-- omp agent in a zellij pane (replaces agentic.nvim)
--
-- The omp-sandboxed TUI runs in a zellij pane named "omp", spawned with
-- Neovim's cwd (omp-sandboxed whitelists $PWD inside the jail). It is a docked
-- side panel by default; <leader>af (flavor) converts it to a floating pane
-- and back, and decides how the next spawn happens. Toggling focuses or hides
-- it; a new session closes the pane and thereby the session.

local M = { flavor = vim.g.omp_agent_flavor or "panel" }

local function zellij(args)
	return vim.fn.system(vim.list_extend({ "zellij", "action" }, args))
end

local function pane_num(id)
	local s = tostring(id)
	local n = s:match("^terminal_(%d+)$") or s:match("^(%d+)$")
	return n and tonumber(n) or nil
end

-- The pane running the agent, or nil outside zellij / without one. Match on
-- the command, the pane name, or pane ids we spawned, so agent panes open in
-- a previous Nvim session, from a session resurrect, or by hand-typed
-- `omp`/omp-sandboxed in any pane are found alike.
local function agent_pane()
	if not vim.env.ZELLIJ then
		return nil
	end
	local out = zellij({ "list-panes", "--state", "--json" })
	if vim.v.shell_error ~= 0 then
		return nil
	end
	local ok, list = pcall(vim.json.decode, out)
	if not ok then
		return nil
	end
	for _, pane in ipairs(list) do
		if pane.is_plugin == false then
			-- json null decodes to vim.NIL, which is truthy: type-check, don't just test
			local cmd = type(pane.terminal_command) == "string" and pane.terminal_command or nil
			local title = type(pane.title) == "string" and pane.title or nil
			if
				(cmd and (cmd:find("omp%-sandboxed") or cmd:find("/omp$") or cmd == "omp"))
				or title == "omp"
				or pane_num(pane.id) == vim.g.omp_agent_pane
			then
				return pane
			end
		end
	end
end

local function spawn(extra)
	-- Absolute path: the zellij server spawns panes with its own environment
	-- and may not have ~/.local / per-user bins on PATH.
	local omp = vim.fn.exepath("omp-sandboxed")
	if omp == "" then
		omp = "omp-sandboxed"
	end
	local cmd = vim.list_extend({ omp }, extra or {})
	local args = { "new-pane" }
	if M.flavor == "float" then
		vim.list_extend(args, { "--floating" })
	else
		vim.list_extend(args, { "--direction", "right" })
	end
	vim.list_extend(args, { "--name", "omp", "--close-on-exit", "--cwd", vim.uv.cwd(), "--" })
	local out = zellij(vim.list_extend(args, cmd))
	local id = (out:gsub("%s+", ""))
	local num = pane_num(id)
	if num then
		vim.g.omp_agent_pane = num
	end
	if M.flavor == "float" then
		return
	end
	-- A fresh docked split lands at 50%; two 10%-shrink steps bring it to the
	-- ~1/3 avante-like sidebar width.
	if num then
		zellij({ "resize", "--pane-id", id, "decrease", "left" })
		zellij({ "resize", "--pane-id", id, "decrease", "left" })
	end
end

local function close_agent()
	local pane = agent_pane()
	if pane then
		vim.g.omp_agent_pane = nil
		zellij({ "close-pane", "--pane-id", pane.id })
	end
end

-- Paste text into the agent's composer without submitting; the question is
-- typed right after the reference. Spawns the agent when absent (pasting is
-- deferred so the TUI is up first) and focuses it in both cases.
local function send(text)
	local pane = agent_pane()
	if not pane then
		spawn()
		vim.defer_fn(function()
			pane = agent_pane()
			if not pane then
				return
			end
			zellij({ "paste", "--pane-id", pane.id, text })
			zellij({ "focus-pane-id", "--pane-id", pane.id })
		end, 2500)
		return
	end
	zellij({ "paste", "--pane-id", pane.id, text })
	zellij({ "focus-pane-id", pane.id })
end

-- Same, but submits the line immediately: Enter is byte 13 (write takes
-- decimal bytes). Used for inline asks with a prefilled question.
local function send_line(text)
	local pane = agent_pane()
	if not pane then
		spawn()
		vim.defer_fn(function()
			pane = agent_pane()
			if not pane then
				return
			end
			zellij({ "paste", "--pane-id", pane.id, text })
			zellij({ "write", "--pane-id", pane.id, "13" })
			zellij({ "focus-pane-id", pane.id })
		end, 2500)
		return
	end
	zellij({ "paste", "--pane-id", pane.id, text })
	zellij({ "write", "--pane-id", pane.id, "13" })
	zellij({ "focus-pane-id", pane.id })
end

-- <leader>aa, pressed from Neovim (so Neovim always holds the focus): focus
-- movement like a sidebar. Floating agent: show+focus or hide (whatever the
-- current float visibility is); docked agent: focus it.
function M.toggle()
	local pane = agent_pane()
	if not pane then
		spawn()
		return
	end
	if pane.is_floating then
		-- are-floating-panes-visible is an honest signal; per-pane is_focused
		-- comes back stale through the CLI connection and once made a focus
		-- press hide the pane instead.
		local visible = zellij({ "are-floating-panes-visible", "--tab-id", pane.tab_id }):find("false") == nil
		if not visible then
			zellij({ "show-floating-panes", "--tab-id", pane.tab_id })
			zellij({ "focus-pane-id", pane.id })
		else
			zellij({ "hide-floating-panes", "--tab-id", pane.tab_id })
			zellij({ "focus-last-pane" })
		end
	else
		zellij({ "focus-pane-id", pane.id })
	end
end

-- <leader>af: dock <-> float. Converts the agent pane live when it exists
-- (the conversion preserves the pane id and its session); otherwise only
-- switches the flavor used by the next spawn.
function M.toggle_flavor()
	local pane = agent_pane()
	if not pane then
		M.flavor = M.flavor == "float" and "panel" or "float"
	else
		zellij({ "focus-pane-id", pane.id })
		zellij({ "toggle-pane-embed-or-floating", "--pane-id", pane.id })
		M.flavor = pane.is_floating and "panel" or "float"
	end
	vim.g.omp_agent_flavor = M.flavor
end

-- <leader>an: fresh agent, dropping the current one; <leader>ar resumes the
-- agent's last session in this directory, <leader>al omp's session picker.
function M.new_session()
	close_agent()
	spawn()
end

function M.continue_session()
	close_agent()
	spawn({ "-c" })
end

function M.select_session()
	close_agent()
	spawn({ "-r" })
end

-- <leader>ax: Esc interrupts omp (same key its TUI uses); send-keys sends a
-- real Esc key event, unlike the decimal byte form.
function M.stop()
	local pane = agent_pane()
	if pane then
		zellij({ "send-keys", "--pane-id", pane.id, "Esc" })
	end
end

-- A context reference for the current situation: in visual/x mode the
-- selection written to ~/.omp/cache/agent-selection.md (inside the
-- omp-sandboxed whitelist), otherwise the current file.
local CACHE = vim.fs.joinpath(vim.uv.os_homedir(), ".omp/cache/agent-selection.md")

local function context_ref()
	if not (vim.fn.mode():find("^[vV\22]")) then
		return "@" .. vim.fn.expand("%:p") .. " "
	end
	-- getpos("'<")/("'>") are unset inside an active <Cmd> mapping, so the
	-- region comes from the visual-start mark and the cursor; linewise needs
	-- an out-of-band column to span the whole last line.
	local mode = vim.fn.mode()
	local start = vim.fn.getpos("v")
	local dot = vim.fn.getpos(".")
	local final = { dot[1], dot[2], mode == "V" and vim.v.maxcol or dot[3], dot[4] }
	local lines = vim.fn.getregion(start, final, { type = mode })
	local from = "| selected from " .. vim.fn.expand("%:~:.") .. ":" .. start[2]
	if final[2] ~= start[2] then
		from = from .. "-" .. final[2]
	end
	vim.fn.mkdir(vim.fs.dirname(CACHE), "p")
	vim.fn.writefile(vim.list_extend({ from }, lines), CACHE)
	return "@" .. CACHE .. " "
end

-- <leader>as: add file/selection as context without submitting.
function M.add_to_context()
	send(context_ref())
end

-- <leader>aq in visual/x mode: ask about the selection like avante's inline
-- prompt — input pops up, the reference and the answer ship in one turn. In
-- normal mode it asks about the current file. Empty input adds context only.
function M.ask()
	local ref = context_ref()
	vim.ui.input({ prompt = "Ask omp: ", default = "" }, function(question)
		if question == nil then
			return -- cancel: leave the agent alone
		elseif question == "" then
			send(ref) -- empty input adds context only
		else
			send_line(ref .. question)
		end
	end)
end

return M
