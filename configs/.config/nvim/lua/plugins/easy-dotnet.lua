require("easy-dotnet").setup({
	managed_terminal = {
		auto_hide = true,
		auto_hide_delay = 1000,
		mappings = {
			next_tab = { lhs = "<Tab>", desc = "Next terminal tab" },
			prev_tab = { lhs = "<S-Tab>", desc = "Previous terminal tab" },
			new_terminal = { lhs = "+", desc = "New user terminal" },
			close_terminal = { lhs = "X", desc = "Close current terminal tab" },
			hide_panel = { lhs = "q", desc = "Hide terminal panel" },
		},
	},
	external_terminal = nil,
	lsp = {
		enabled = true,
		set_fold_expr = false,
		preload_roslyn = true,
		roslynator_enabled = true,
		easy_dotnet_analyzer_enabled = true,
		auto_refresh_codelens = true,
		analyzer_assemblies = {},
		config = {},
	},
	debugger = {
		bin_path = nil,
		console = "integratedTerminal",
		apply_value_converters = true,
		auto_register_dap = true,
		mappings = {
			open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
		},
	},
	test_runner = {
		auto_start_testrunner = true,
		hide_legend = false,
		viewmode = "float",
		vsplit_width = nil,
		vsplit_pos = nil,
		icons = {
			passed = "",
			skipped = "",
			failed = "",
			success = "",
			reload = "",
			test = "",
			sln = "󰘐",
			project = "󰘐",
			dir = "",
			package = "",
			class = "",
			build_failed = "󰒡",
		},
		mappings = {
			run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
			run_all_tests_from_buffer = { lhs = "<leader>t", desc = "Run all tests in file" },
			get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
			peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
			debug_test_from_buffer = { lhs = "<leader>d", desc = "run test from buffer" },
			debug_test = { lhs = "<leader>d", desc = "debug test" },
			go_to_file = { lhs = "g", desc = "go to file" },
			run_all = { lhs = "<leader>R", desc = "run all tests" },
			run = { lhs = "<leader>r", desc = "run test" },
			peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
			expand = { lhs = "o", desc = "expand" },
			expand_node = { lhs = "E", desc = "expand node" },
			collapse_all = { lhs = "W", desc = "collapse all" },
			close = { lhs = "q", desc = "close testrunner" },
			refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
			cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
		},
	},
	new = {
		project = {
			prefix = "sln",
		},
	},
	csproj_mappings = true,
	fsproj_mappings = true,
	auto_bootstrap_namespace = {
		type = "block_scoped",
		enabled = true,
		use_clipboard_json = {
			behavior = "prompt",
			register = "+",
		},
	},
	server = {
		log_level = nil,
	},
	picker = "telescope",
	background_scanning = true,
	notifications = {
		handler = function(start_event)
			local spinner = require("easy-dotnet.ui-modules.spinner").new()
			spinner:start_spinner(start_event.job.name)
			return function(finished_event)
				spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
			end
		end,
	},
	diagnostics = {
		default_severity = "error",
		setqflist = false,
	},
	outdated = {
		mappings = {
			upgrade = { lhs = "<leader>pu", desc = "upgrade package under cursor" },
			upgrade_all = { lhs = "<leader>pa", desc = "upgrade all outdated packages" },
		},
	},
})
