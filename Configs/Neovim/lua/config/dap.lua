Dap = require("dap")
DapUi = require("dapui")
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
