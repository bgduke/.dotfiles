require("mason-nvim-dap").setup({
	ensure_installed = { "cppdbg" },
	handlers = {},
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.keymap.set("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP continue" })
vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP step over" })
vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end, { desc = "DAP step into" })
vim.keymap.set("n", "<F12>", function()
	dap.step_out()
end, { desc = "DAP step out" })
vim.keymap.set("n", "<F9>", function()
	dap.toggle_breakpoint()
end, { desc = "DAP toggle breakpoint" })
vim.keymap.set("n", "<Leader>B", function()
	dap.set_breakpoint()
end, { desc = "DAP set breakpoint" })
