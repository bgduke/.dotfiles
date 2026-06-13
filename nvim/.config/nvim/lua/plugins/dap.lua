vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/nvim-neotest/nvim-nio",
})
vim.pack.add({ "https://github.com/rcarriga/nvim-dap-ui" })

local dap = require("dap")
local dapui = require("dapui")

dap.defaults["easy-dotnet"].exception_breakpoints = { "all", "user-unhandled" }
dap.defaults.fallback.exception_breakpoints = { "all", "user-unhandled" }

dapui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint", linehl = "", numhl = "" })

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

local map = function(keys, rhs, desc)
	vim.keymap.set("n", keys, rhs, { desc = "DAP: " .. desc, noremap = true, silent = true })
end

map("<F5>", dap.continue, "Continue")
map("<F10>", dap.step_over, "Step Over")
map("<F11>", dap.step_into, "Step Into")
map("<F12>", dap.step_out, "Step Out")
map("<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
map("<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Conditional Breakpoint")
map("<leader>dl", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "Log Point")
map("<leader>dr", dap.repl.open, "Open REPL")
map("<leader>du", dapui.toggle, "Toggle UI")
map("<leader>dt", dap.terminate, "Terminate")
map("<leader>dh", require("dap.ui.widgets").hover, "Hover")
map("<leader>de", dap.set_exception_breakpoints, "Set Exception Breakpoints")
map("<leader>dE", function()
	local session = dap.session()
	local filters = session and session.capabilities and session.capabilities.exceptionBreakpointFilters
	vim.notify(vim.inspect(filters or {}), vim.log.levels.INFO, { title = "DAP exception filters" })
end, "Show Exception Filters")
