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
			picker = {
				cwd = vim.fn.getcwd(),
				files = {
					hidden = true,
					ignored = false,
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
					Snacks.picker.smart()
				end,
				desc = "Find Files",
			},

			{
				"<leader>fa",
				function()
					Snacks.picker.files()
				end,
				desc = "Find all Files",
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
		},
	},
}
