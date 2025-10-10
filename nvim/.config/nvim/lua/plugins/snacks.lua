return {
	{
		"folke/snacks.nvim",
		event = "VeryLazy",
		opts = {
			bigfile = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			image = {
				enabled = false,
			},
			picker = {
				enabled = true,
				cwd = vim.fn.getcwd(),
				exclude = {
					-- Package managers
					"node_modules",
					"pnpm-lock.yaml",
					"package-lock.json",
					"yarn.lock",
					"Cargo.lock",
					"composer.lock",
					"poetry.lock",
					"Pipfile.lock",
					"go.sum",
					"mix.lock",

					-- Build outputs
					"dist",
					"build",
					"target",
					".next",
					".nuxt",
					"out",
					"public/build",
					"_site",

					-- Dependencies/vendor
					".venv",
					"venv",
					"env",
					"vendor",
					".virtualenv",
					"__pycache__",
					"*.pyc",

					-- IDE/Editor files
					".vscode",
					".idea",
					"*.swp",
					"*.swo",
					"*~",
					".DS_Store",
					"Thumbs.db",

					-- Version control
					".git",
					".svn",
					".hg",

					-- Logs and temp files
					"*.log",
					"logs",
					"tmp",
					"temp",
					".tmp",
					".cache",

					-- OS generated
					".Trash",
					".Trashes",
					"ehthumbs.db",

					-- Language specific
					"*.min.js",
					"*.min.css",
					".coverage",
					"coverage",
					"*.tsbuildinfo",
					".nyc_output",
					"*.egg-info",
					".pytest_cache",
					".mypy_cache",
					".ruff_cache",
				},
				files = {
					hidden = true,
					ignored = true,
				},
				layout = {
					preset = "default",
				},
				layouts = {
					-- I wanted to modify the ivy layout height and preview pane width,
					-- this is the only way I was able to do it
					-- NOTE: I don't think this is the right way as I'm declaring all the
					-- other values below, if you know a better way, let me know
					--
					-- Then call this layout in the keymaps above
					-- got example from here
					-- https://github.com/folke/snacks.nvim/discussions/468
					default = {
						layout = {
							box = "horizontal",
							width = 0.9,
							min_width = 120,
							height = 0.8,
							{
								box = "vertical",
								border = "none",
								title = "{title} {live} {flags}",
								-- the input window
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
							},
							-- the preview window
							{ win = "preview", title = "{preview}", border = "left", width = 0.6 },
						},
					},
				},
				win = {
					input = {
						keys = {
							["/"] = "toggle_focus",
							["<CR>"] = { "confirm", mode = { "n", "i" } },
							["<Down>"] = { "list_down", mode = { "i", "n" } },
							["<Esc>"] = "close",
							["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
							["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						},
						b = {
							minipairs_disable = true,
						},
					},
				},
			},
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {},
		},
		keys = {
			{
				"<leader>nh",
				function()
					if Snacks.config.picker and Snacks.config.picker.enabled then
						Snacks.picker.notifications()
					else
						Snacks.notifier.show_history()
					end
				end,
				desc = "Notification History",
			},
			{
				"<leader>ff",
				function()
					dofile(vim.g.base46_cache .. "treesitter")
					dofile(vim.g.base46_cache .. "syntax")
					Snacks.picker.files({})
				end,
				desc = "Find Files",
			},

			{
				"<leader>fa",
				function()
					Snacks.picker.files({
						hidden = true,
						ignored = true,
						exclude = {
							-- Keep only the most essential exclusions
							"node_modules",
							".git",
							"dist",
							"build",
							"target",
						},
						files = {
							hidden = true,
							ignored = true,
						},
					})
				end,
				desc = "Find All Files",
			},
			{
				"<leader>fw",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "search keymaps",
			},
			{
				"<leader>j",
				function()
					Snacks.scope.jump()
				end,
				desc = "Jump to current top scope",
			},
			{
				"<leader>u",
				function()
					Snacks.picker.undo()
				end,
				desc = "Jump to current top scope",
			},
			{
				"<leader>fs",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Symbols",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			{
				"<leader>fS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers({
						finder = "buffers",
						format = "buffer",
						hidden = false,
						unloaded = true,
						current = true,
						sort_lastused = true,
						win = {
							input = {
								keys = {
									["d"] = "bufdelete",
								},
							},
							list = { keys = { ["d"] = "bufdelete" } },
						},
					})
				end,
				desc = "Buffers",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>tb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git blame line",
			},
		},
	},
}
