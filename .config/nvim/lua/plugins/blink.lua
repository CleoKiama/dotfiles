return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"disrupted/blink-cmp-conventional-commits",
			"moyiz/blink-emoji.nvim",
			{
				"saghen/blink.compat",
				opts = {},
			},
		},
		event = { "InsertEnter" },
		opts = {
			cmdline = {
				keymap = {
					["<Tab>"] = { "accept" },
					-- ["<CR>"] = { "accept_and_enter", "fallback" },
				},
				completion = {
					menu = { auto_show = true },
				},
			},
			completion = {
				menu = { auto_show = true },
				documentation = {
					auto_show = true,
				},
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = {
					"snippets",
					"lsp",
					"path",
					"buffer",
					"emoji",
				},
				per_filetype = {
					sql = { "dadbod" },
					lua = { "lazydev" },
					git = { "conventional_commits" },
					NeogitCommitMessage = { "conventional_commits" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
						min_keyword_length = 2,
						score_offset = 85,
					},
					snippets = {
						name = "snippets",
						enabled = true,
						max_items = 30,
						min_keyword_length = 1,
						module = "blink.cmp.sources.snippets",
						score_offset = 80,
					},
					conventional_commits = {
						name = "Conventional Commits",
						module = "blink-cmp-conventional-commits",
						enabled = function()
							return vim.bo.filetype == "gitcommit"
						end,
						---@module 'blink-cmp-conventional-commits'
						---@type blink-cmp-conventional-commits.Options
						opts = {}, -- none so far
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},
				},
			},
			keymap = {
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-y>"] = { "select_and_accept" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
			},
		},
	},
}
