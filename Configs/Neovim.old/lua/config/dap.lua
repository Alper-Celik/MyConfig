Dap = require("dap")
DapUi = require("dapui")

---- dap and such
vim.keymap.set("n", "<Leader>B", Dap.set_breakpoint)
vim.keymap.set("n", "<Leader>b", Dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>dbb", Dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>dbl", function()
	Dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dg", Dap.run_to_cursor)
vim.keymap.set("n", "<Leader>dr", Dap.repl.open)

-- Eval var under cursor
vim.keymap.set("n", "<Leader>d?", function()
	DapUi.eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F5>", function()
	if Dap.session() == nil and (vim.bo.filetype == "cpp" or vim.bo.filetype == "c") then
		-- Only call this on C++ and C files
		require("ctest-telescope").pick_test_and_debug()
	else
		Dap.continue()
	end
end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F10>", Dap.step_over)
vim.keymap.set("n", "<F11>", Dap.step_into)
vim.keymap.set("n", "<F12>", Dap.step_out)

vim.keymap.set("n", "<Leader>dl", function()
	Dap.run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)

require("nvim-dap-virtual-text").setup({
	commented = true,
})

Dap.listeners.before.attach.dapui_config = function()
	DapUi.open()
end
Dap.listeners.before.launch.dapui_config = function()
	DapUi.open()
end
Dap.listeners.before.event_terminated.dapui_config = function()
	DapUi.close()
end
Dap.listeners.before.event_exited.dapui_config = function()
	DapUi.close()
end

Dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}
Dap.adapters.lldb = {
	type = "executable",
	command = vim.fn.exepath("lldb-vscode"), -- adjust as needed, must be absolute path
	name = "lldb",
}
