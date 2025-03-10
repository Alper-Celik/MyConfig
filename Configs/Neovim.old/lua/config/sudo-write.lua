--sudo write
vim.api.nvim_create_user_command("Sw", function()
	--from https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua

	local sudo_exec = function(cmd, print_output)
		vim.fn.inputsave()
		local password = vim.fn.inputsecret("Password: ")
		vim.fn.inputrestore()
		if not password or #password == 0 then
			print("Invalid password, sudo aborted")
			return false
		end
		local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
		if vim.v.shell_error ~= 0 then
			print("\r\n")
			print(out)
			return false
		end
		if print_output then
			print("\r\n", out)
		end
		return true
	end

	local tmpfile = vim.fn.tempname()
	local filepath = vim.fn.expand("%")
	if not filepath or #filepath == 0 then
		print("No file name")
		return
	end
	-- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
	-- Both `bs=1M` and `bs=1m` are non-POSIX
	local cmd = string.format("dd if=%s of=%s bs=1048576", vim.fn.shellescape(tmpfile), vim.fn.shellescape(filepath))
	-- no need to check error as this fails the entire function
	vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
	if sudo_exec(cmd) then
		print(string.format('\r\n"%s" written', filepath))
		vim.cmd("e!")
	end
	vim.fn.delete(tmpfile)
end, {})
