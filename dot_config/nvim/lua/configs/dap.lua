local dv_loaded, dv = pcall(require, "dap-view")
local dap_loaded, dap = pcall(require, "dap")
local vt_loaded, dap_vt = pcall(require, "nvim-dap-virtual-text")
local utils_loaded, _dap_utils = pcall(require, "dap.utils")

if not dv_loaded or not dap_loaded or not vt_loaded or not utils_loaded then
	vim.notify("DAP dependencies are missing. Please install them.")
	return
end

-- DAP Virtual Text Setup
dap_vt.setup({
	enabled = true, -- Enable plugin (default)
	enabled_commands = true, -- Create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
	highlight_changed_variables = true, -- Highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
	highlight_new_as_changed = false, -- Highlight new variables in the same way as changed variables (if highlight_changed_variables)
	show_stop_reason = true, -- Show stop reason when stopped for exceptions
	commented = false, -- Prefix virtual text with comment string
	only_first_definition = true, -- Only show virtual text at first definition (if there are multiple)
	all_references = false, -- Show virtual text on all references of the variable (not only definitions)
	filter_references_pattern = "<module", -- Filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
	-- Experimental Features:
	virt_text_pos = "eol", -- Position of virtual text, see `:h nvim_buf_set_extmark()`
	all_frames = false, -- Show virtual text for all stack frames not only current. Only works for debugpy on my machine.
	virt_lines = false, -- Show virtual lines instead of virtual text (will flicker!)
	virt_text_win_col = nil, -- Position the virtual text at a fixed window column (starting from the first text column)
})

-- nvim-dap-view Setup (replaces nvim-dap-ui)
dv.setup({
	auto_toggle = true,
	windows = {
		position = "left",
		size = 40,
		terminal = {
			position = "bottom",
			size = 0.25,
		},
	},
})

-- DAP Setup
dap.set_log_level("TRACE")

-- Enable virtual text
vim.g.dap_virtual_text = true

-- Icons
vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = 8123,
	executable = {
		command = "js-debug-adapter",
	},
}

local supported_filetypes = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

for _, language in ipairs(supported_filetypes) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "debug with nodejs",
			program = "${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
	}
end

require("dap-python").setup("uv")

local function set_step_keymaps()
	local actions = {
		["<Down>"] = "step_over",
		["<Right>"] = "step_into",
		["<Left>"] = "step_out",
		["<Up>"] = "restart_frame",
	}
	for key, action in pairs(actions) do
		vim.keymap.set("n", key, function()
			require("dap")[action]()
		end, { noremap = true, silent = true, desc = "DAP " .. action })
	end
end

local function clear_step_keymaps()
	for _, key in ipairs({ "<Down>", "<Right>", "<Left>", "<Up>" }) do
		pcall(vim.keymap.del, "n", key)
	end
end

dap.listeners.after.event_initialized["step_keys"] = set_step_keymaps
dap.listeners.before.event_terminated["step_keys"] = clear_step_keymaps
dap.listeners.before.event_exited["step_keys"] = clear_step_keymaps
