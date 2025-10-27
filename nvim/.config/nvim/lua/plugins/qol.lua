local leet_arg = "leetcode.nvim"
vim.g.cord_defer_startup = true

return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		keys = {
			{ "<leader>sn", "", desc = "+noice" },
			{
				"<S-Enter>",
				function()
					require("noice").redirect(vim.fn.getcmdline())
				end,
				mode = "c",
				desc = "Redirect Cmdline",
			},
			{
				"<leader>nl",
				function()
					require("noice").cmd("last")
				end,
				desc = "Noice Last Message",
			},
			{
				"<leader>nc",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = "Dismiss All",
			},
			{
				"<c-f>",
				function()
					if not require("noice.lsp").scroll(4) then
						return "<c-f>"
					end
				end,
				silent = true,
				expr = true,
				desc = "Scroll Forward",
				mode = { "i", "n", "s" },
			},
			{
				"<c-b>",
				function()
					if not require("noice.lsp").scroll(-4) then
						return "<c-b>"
					end
				end,
				silent = true,
				expr = true,
				desc = "Scroll Backward",
				mode = { "i", "n", "s" },
			},
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.harpoon")
		end,
	},
	{
		"preservim/vimux",
	},
	{
		"CRAG666/code_runner.nvim",
		dependencies = { "preservim/vimux" },
		config = function()
			require("configs.code_runner")
		end,
		keys = {
			{
				"<leader>cr",
				function()
					vim.cmd("VimuxClearTerminalScreen")
					vim.cmd("RunCode")
				end,
				desc = "[p] Run code",
			},
			{
				"<leader>ci",
				"<cmd>VimuxInspectRunner<CR>",
				desc = "Inspect the code in the terminal",
			},
		},
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		event = "InsertEnter",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		cmd = "Oil",
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			win = {
				position = "right", -- Opens Trouble in a vertical split on the right
				width = 40, -- Width of the vertical split
			},
		},
		confg = function(_, opts)
			-- dofile(vim.g.base46_cache .. "trouble")
			require("trouble").setup(opts)
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.todoComment")
		end,
	},
	{
		"simeji/winresizer",
		cmd = "WinResizerStartResize",
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", "<Plug>(leap)", desc = "Leap" },
		},
	},
	{
		"axelvc/template-string.nvim",
		ft = { "html", "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte", "python" },
		config = function()
			require("template-string").setup({
				filetypes = {
					"html",
					"typescript",
					"javascript",
					"typescriptreact",
					"javascriptreact",
					"vue",
					"svelte",
					"python",
				},
				jsx_brackets = true, -- must add brackets to JSX attributes
				remove_template_string = false, -- remove backticks when there are no template strings
				restore_quotes = {
					-- quotes used when "remove_template_string" option is enabled
					normal = [[']],
					jsx = [["]],
				},
			})
		end,
	},
	{
		"tzachar/highlight-undo.nvim",
		config = function()
			require("highlight-undo").setup({
				keymaps = {
					paste = {
						desc = "paste",
						hlgroup = "HighlightUndo",
						mode = "n",
						lhs = "p",
						rhs = "p",
						opts = {},
					},
				},
			})
		end,
		keys = { { "u" }, { "<C-r>" } },
	},
	{
		"Vigemus/iron.nvim",
		cmd = "IronRepl",
		config = function()
			require("configs.iron")
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = { "BufRead", "BufNewFile", "BufWritePost" },
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"astro",
			"glimmer",
			"handlebars",
			"html",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"jsx",
			"markdown",
			"php",
			"rescript",
			"svelte",
			"tsx",
			"twig",
			"vue",
			"xml",
		},
		config = function()
			require("configs.nvim-ts-autotag")
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		lazy = leet_arg ~= vim.fn.argv(0, -1),
		dependencies = {
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",
			-- optional
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("configs.leetcode")
		end,
	},
	{
		"Goose97/timber.nvim",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = { "BufReadPre" },
		config = function()
			require("timber").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"Wansmer/treesj",
		cmd = { "TSJSplit", "TSJJoin" },
		keys = {
			{ "<leader>cj", "<cmd>TSJToggle<CR>", desc = "Toggle code join/split" },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
		end,
	},
	{
		"wakatime/vim-wakatime",
		event = "VeryLazy",
	},
	{
		"jellydn/hurl.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown" },
				},
				ft = { "markdown" },
			},
		},
		ft = "hurl",
		opts = {
			debug = false,
			show_notification = false,
			mode = "split",
			formatters = {
				json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
				html = {
					"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
					"--parser",
					"html",
				},
				xml = {
					"tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
					"-xml",
					"-i",
					"-q",
				},
			},
			mappings = {
				close = "q",
				next_panel = "<M-n>",
				prev_panel = "<M-p>",
			},
		},
		keys = {
			{ "<localleader>hr", "<cmd>HurlRunner<CR>", desc = "Hurl run all requests" },
			{ "<localleader>ha", "<cmd>HurlRunnerAt<CR>", desc = "Hurl run at cursor" },
			{ "<localleader>he", "<cmd>HurlRunnerToEntry<CR>", desc = "Hurl run to entry" },
			{ "<localleader>hE", "<cmd>HurlRunnerToEnd<CR>", desc = "Hurl run to end" },
			{ "<localleader>hm", "<cmd>HurlToggleMode<CR>", desc = "Hurl toggle mode" },
			{ "<localleader>hv", "<cmd>HurlVerbose<CR>", desc = "Hurl verbose mode" },
			{ "<localleader>hl", "<cmd>HurlShowLastResponse<CR>", desc = "Hurl last response" },
			{ "<localleader>hV", "<cmd>HurlVeryVerbose<CR>", desc = "Hurl very verbose mode" },
			{
				"<localleader>h",
				":HurlRunner<CR>",
				desc = "Hurl run selection",
				mode = "v",
			},
		},
	},
	{
		"jake-stewart/multicursor.nvim",
		event = "BufRead",
		branch = "1.0",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local set = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			set({ "n", "x" }, "<up>", function()
				mc.lineAddCursor(-1)
			end)
			set({ "n", "x" }, "<down>", function()
				mc.lineAddCursor(1)
			end)
			set({ "n", "x" }, "<leader><up>", function()
				mc.lineSkipCursor(-1)
			end)
			set({ "n", "x" }, "<leader><down>", function()
				mc.lineSkipCursor(1)
			end)

			-- Add or skip adding a new cursor by matching word/selection
			set({ "n", "x" }, "<localleader>n", function()
				mc.matchAddCursor(1)
			end)
			set({ "n", "x" }, "<localleader>s", function()
				mc.matchSkipCursor(1)
			end)
			set({ "n", "x" }, "<localleader>N", function()
				mc.matchAddCursor(-1)
			end)
			set({ "n", "x" }, "<localleader>S", function()
				mc.matchSkipCursor(-1)
			end)

			-- Add and remove cursors with control + left click.
			set("n", "<c-leftmouse>", mc.handleMouse)
			set("n", "<c-leftdrag>", mc.handleMouseDrag)
			set("n", "<c-leftrelease>", mc.handleMouseRelease)

			-- Disable and enable cursors.
			set({ "n", "x" }, "<c-q>", mc.toggleCursor)

			-- Mappings defined in a keymap layer only apply when there are
			-- multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Select a different cursor as the main one.
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)

				-- Delete the main cursor.
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

			-- Customize how cursors look.
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { reverse = true })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { reverse = true })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
	{
		"vyfor/cord.nvim",
		build = ":Cord update",
		keys = {
			{
				"<leader>dp",
				function()
					require("cord").setup({
						-- Configuration here, or leave empty to use defaults
						-- For more options, see:
					})
				end,
				desc = "start discord rich presence",
			},
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					-- Display the source of diagnostics (e.g., "lua_ls", "pyright")
					show_source = {
						enabled = false, -- Enable showing source names
						if_many = false, -- Only show source if multiple sources exist for the same diagnostic
					},

					-- Use icons from vim.diagnostic.config instead of preset icons
					use_icons_from_diagnostic = false,

					-- Color the arrow to match the severity of the first diagnostic
					set_arrow_to_diag_color = false,

					-- Throttle update frequency in milliseconds to improve performance
					-- Higher values reduce CPU usage but may feel less responsive
					-- Set to 0 for immediate updates (may cause lag on slow systems)
					throttle = 100,

					-- Minimum number of characters before wrapping long messages
					softwrap = 30,

					-- Control how diagnostic messages are displayed
					-- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
					--       If you want them to always be displayed, you can also set multilines.always_show = true.
					add_messages = {
						messages = true, -- Show full diagnostic messages
						display_count = false, -- Show diagnostic count instead of messages when cursor not on line
						use_max_severity = false, -- When counting, only show the most severe diagnostic
						show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
					},

					-- Settings for multiline diagnostics
					multilines = {
						enabled = true, -- Enable support for multiline diagnostic messages
						always_show = false, -- Always show messages on all lines of multiline diagnostics
						trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
						tabstop = 4, -- Number of spaces per tab when expanding tabs
						severity = nil, -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
					},

					-- Show all diagnostics on the current cursor line, not just those under the cursor
					show_all_diags_on_cursorline = false,

					-- Display related diagnostics from LSP relatedInformation
					show_related = {
						enabled = true, -- Enable displaying related diagnostics
						max_count = 3, -- Maximum number of related diagnostics to show per diagnostic
					},

					-- Enable diagnostics display in insert mode
					-- May cause visual artifacts; consider setting throttle to 0 if enabled
					enable_on_insert = false,

					-- Enable diagnostics display in select mode (e.g., during auto-completion)
					enable_on_select = false,

					-- Handle messages that exceed the window width
					overflow = {
						mode = "wrap", -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
						padding = 0, -- Extra characters to trigger wrapping earlier
					},

					-- Break long messages into separate lines
					break_line = {
						enabled = false, -- Enable automatic line breaking
						after = 30, -- Number of characters before inserting a line break
					},

					-- Custom function to format diagnostic messages
					-- Receives diagnostic object, returns formatted string
					-- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
					format = nil,

					-- Virtual text display priority
					-- Higher values appear above other plugins (e.g., GitBlame)
					virt_texts = {
						priority = 2048,
					},

					-- Automatically disable diagnostics when opening diagnostic float windows
					override_open_float = true,
				},
			})
		end,
	},
}
