require("neotest").setup({
	adapters = {
		require("neotest-jest")({
			jestCommand = "npm test --",
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(_)
				return vim.fn.getcwd()
			end,
		}),
		-- Removed rustaceanvim.neotest to use vimux for rust tests
	},
	discovery = {
		enabled = true,
		filter_dir = function(name, rel_path, root)
			local excluded_dirs = {
				"node_modules",
				"dist",
				"build",
				"target", -- Rust
				".git", -- Git metadata
				".cargo", -- Rust-related cache
				".next", -- Next.js build folder
				".turbo", -- Turborepo build folder
				"venv", -- Python virtual envs
			}

			for _, dir in ipairs(excluded_dirs) do
				if name == dir then
					return false
				end
			end

			return true
		end,
	},
	diagnostic = {
		enabled = true,
	},
	floating = {
		border = "rounded",
		max_height = 0.6,
		max_width = 0.6,
	},
	highlights = {
		adapter_name = "NeotestAdapterName",
		border = "NeotestBorder",
		dir = "NeotestDir",
		expand_marker = "NeotestExpandMarker",
		failed = "NeotestFailed",
		file = "NeotestFile",
		focused = "NeotestFocused",
		indent = "NeotestIndent",
		namespace = "NeotestNamespace",
		passed = "NeotestPassed",
		running = "NeotestRunning",
		skipped = "NeotestSkipped",
		test = "NeotestTest",
	},
	icons = {
		child_indent = "│",
		child_prefix = "├",
		collapsed = "─",
		expanded = "▼",
		failed = "❌",
		final_child_indent = " ",
		final_child_prefix = "╰",
		non_collapsible = "─",
		passed = "✅",
		running = "🏃",
		skipped = "ﰸ",
		unknown = "?",
	},
	output = {
		enabled = true,
		open_on_run = true,
	},
	run = {
		enabled = true,
	},
	status = {
		enabled = true,
	},
	strategies = {
		integrated = {
			height = 40,
			width = 120,
		},
	},
	summary = {
		enabled = true,
		expand_errors = true,
		follow = true,
		mappings = {
			attach = "a",
			expand = { "<CR>", "<2-LeftMouse>" },
			expand_all = "e",
			jumpto = "i",
			output = "o",
			run = "r",
			short = "O",
			stop = "u",
		},
	},
})
