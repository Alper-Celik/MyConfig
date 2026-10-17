-- ai generated
-- agentic.nvim perf patch: its status spinner copies the WHOLE chat buffer to find the last
-- line, and SessionManager restarts the spinner on every streamed chunk (each restart paints a
-- frame immediately), so a long session copies the whole transcript thousands of times per turn.
-- Measured on a 50k-line pane: 1511 frames = 12.9s of main-loop time in a 40s turn (~9ms per
-- frame, max 49ms) — Neovim is effectively hung until the turn ends.
--
-- See agentic/ui/status_animation.lua:_render_frame; upstream fix is to use
-- `vim.api.nvim_buf_line_count(self._bufnr) - 1` instead of `#nvim_buf_get_lines(buf, 0, -1)`.
-- Delete this file once that lands (check `:Lazy log agentic.nvim`).
local TIMING = { generating = 200, thinking = 600, searching = 600, busy = 100 }

local M = {}

function M.apply()
  local StatusAnimation = require("agentic.ui.status_animation")
  local Config = require("agentic.config")
  local Theme = require("agentic.theme")
  local BufHelpers = require("agentic.utils.buf_helpers")
  local ns = vim.api.nvim_create_namespace("agentic_animation")

  StatusAnimation._render_frame = function(self, epoch)
    if epoch ~= self._epoch then return end
    if not self._state or not vim.api.nvim_buf_is_valid(self._bufnr) then return end

    local spinner_chars = Config.spinner_chars[self._state] or Config.spinner_chars.generating
    local char = spinner_chars[self._spinner_idx] or spinner_chars[1]
    self._spinner_idx = (self._spinner_idx % #spinner_chars) + 1

    local display_text = string.format(" %s %s ", char, self._state)
    local hl_group = Theme.get_spinner_hl_group(self._state)

    -- the one line that matters: line count, not a copy of every line
    local line_num = math.max(0, vim.api.nvim_buf_line_count(self._bufnr) - 1)

    local virt_text = { { display_text, hl_group } }

    -- A background session animates in its own tab, so the centring padding must measure that window.
    local winid = BufHelpers.find_visible_win(self._bufnr)
    if winid then
      local win_width = vim.api.nvim_win_get_width(winid)
      local text_width = vim.fn.strdisplaywidth(display_text)
      if win_width > text_width then
        local padding = math.floor((win_width - text_width) / 2)
        table.insert(virt_text, 1, { string.rep(" ", padding), "Normal" })
      end
    end

    local delay = TIMING[self._state] or TIMING.generating

    -- Repainting the spinner re-lays out the lines above `virt_lines`, which jerks the view
    -- while the answer streams. Only paint when the buffer has settled; while text is arriving
    -- the new text is feedback enough.
    local tick = vim.api.nvim_buf_get_changedtick(self._bufnr)
    if self._agentic_last_tick ~= tick and self._agentic_last_tick ~= nil then
      self._agentic_last_tick = tick
      self._next_frame_handle = vim.defer_fn(function()
        self:_render_frame(epoch)
      end, delay)
      return
    end
    self._agentic_last_tick = tick

    local virt_lines = { { { "" } }, virt_text, { { "" } } }

    self._extmark_id =
      vim.api.nvim_buf_set_extmark(self._bufnr, ns, line_num, 0, {
        id = self._extmark_id,
        virt_lines = virt_lines,
        virt_lines_above = false,
      })

    self._next_frame_handle = vim.defer_fn(function()
      self:_render_frame(epoch)
    end, delay)
  end

  -- Same bug class: `BufHelpers.is_buffer_empty` copies *every* line of the chat buffer
  -- (nvim_buf_get_lines(buf, 0, -1)) just to see whether any line has content, and
  -- MessageWriter calls it on every appended block. Search the buffer in place instead.
  -- Measured on a 40k-line pane: 24 calls / 157 ms per turn, worst 18.7 ms.
  -- Upstream fix: same change in agentic/utils/buf_helpers.lua:is_buffer_empty.
  BufHelpers.is_buffer_empty = function(bufnr)
    return vim.api.nvim_buf_call(bufnr, function()
      return vim.fn.search("\\S", "nw") == 0
    end)
  end

  -- Coalesce streamed chunks: agentic does one buffer write (and therefore one repaint, one
  -- TextChanged, one auto-scroll) per ACP chunk, and omp emits ~2000 chunks per turn — thinking
  -- included. Merge chunks into per-kind runs and flush at ~30Hz: measured 6x fewer writes at
  -- omp's real ~200 chunk/s (200 -> 33/s), order preserved. `vim.g.agentic_no_coalesce = true`
  -- turns this off if it ever misbehaves.
  local MessageWriter = require("agentic.ui.message_writer")
  local orig_chunk = MessageWriter.write_message_chunk
  local queue, timer

  local function flush()
    if timer then
      timer:stop()
      timer:close()
      timer = nil
    end
    if not queue then return end
    local pending = queue
    queue = nil
    for _, segment in ipairs(pending) do
      M.flushes = (M.flushes or 0) + 1
      orig_chunk(segment.writer, {
        sessionUpdate = segment.kind,
        content = { type = "text", text = segment.text },
      })
    end
  end
  M.flush = flush

  if not vim.g.agentic_no_coalesce then
    for _, name in ipairs({
      "write_message",
      "write_structural_message",
      "write_restoring_message",
      "write_tool_call_block",
      "update_tool_call_block",
      "write_finish_message",
      "replay_history_messages",
      "set_permission_state",
    }) do
      local orig = MessageWriter[name]
      if orig then
        MessageWriter[name] = function(self, ...)
          flush()
          return orig(self, ...)
        end
      end
    end

    MessageWriter.write_message_chunk = function(self, update)
      local content = update and update.content
      if not (content and content.type == "text" and content.text and content.text ~= "") then
        flush()
        return orig_chunk(self, update)
      end

      local kind = update.sessionUpdate
      queue = queue or {}
      local last = queue[#queue]
      if last and last.kind == kind and last.writer == self then
        last.text = last.text .. content.text
      else
        queue[#queue + 1] = { kind = kind, writer = self, text = content.text }
      end

      if not timer then
        timer = assert(vim.uv.new_timer())
        timer:start(33, 33, vim.schedule_wrap(flush))
      end
    end
  end

  -- The spinner is restarted on every chunk, and each start paints a frame (extmark + virt_lines
  -- invalidation). Same state within 200ms is redundant.
  local SessionManager = require("agentic.session_manager")
  local orig_spinner = SessionManager._start_spinner
  local last_state, last_at = nil, 0
  SessionManager._start_spinner = function(self, state)
    local t = vim.uv.hrtime()
    if state == last_state and (t - last_at) < 200e6 then return end
    last_state, last_at = state, t
    return orig_spinner(self, state)
  end

  -- Markdown rendering only between turns. render-markdown re-renders the whole buffer on every
  -- change (conceals appear/disappear), which fights the streamed writes, so AgenticChat is in
  -- its file_types and is switched off while a turn streams, back on when the answer is done:
  -- tables/headings appear once the response is complete, streaming stays plain and flicker-free.
  local function set_md(bufnr, enable)
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
    -- resolved per call: render-markdown may still be lazy-loading when this patch is applied
    local ok, RenderMarkdown = pcall(require, "render-markdown.core.manager")
    if ok and RenderMarkdown.attached(bufnr) then
      RenderMarkdown.set_buf(bufnr, enable)
      M.md_calls = (M.md_calls or 0) + 1
    end
  end

  local orig_submit = SessionManager._handle_input_submit
  SessionManager._handle_input_submit = function(self, input_text)
    set_md(self.widget and self.widget.buf_nrs and self.widget.buf_nrs.chat, false)
    return orig_submit(self, input_text)
  end

  local orig_complete = SessionManager.complete_start
  SessionManager.complete_start = function(self, spec, result, err)
    orig_complete(self, spec, result, err)
    if spec and spec.kind == "load" then
      set_md(self.widget and self.widget.buf_nrs and self.widget.buf_nrs.chat, true)
    end
  end

  local orig_finish = MessageWriter.write_finish_message
  MessageWriter.write_finish_message = function(self, ...)
    local result = orig_finish(self, ...)
    set_md(self.bufnr, true)
    return result
  end

  M.applied = true
end

return M
