return {
	ensure_installed = {
		--defaults
		"vim",
		"lua",
		"vimdoc",
		"html",
		"bash",
		"hurl",
		"css",
		"javascript",
		"typescript",
		"markdown",
		"markdown_inline",
		"tsx",
		"prisma",
		"json",
		"yaml",
		"toml",
		"jsonc",
		"python",
		"sql",
		"regex",
		"elixir",
		"gleam",
		"rust",
	},
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	indent = { enable = true },
	--  nvim-treesitter/nvim-treesitter-textobjects config
	textobjects = {
		lsp_interop = {
			enable = true,
			border = "none",
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ip"] = "@parameter.inner", -- Added
				["ap"] = "@parameter.outer", -- Added
				["is"] = "@statement.outer", -- Added
			},
			selection_modes = {
				["@parameter.outer"] = "v",
				["@function.outer"] = "V",
				["@class.outer"] = "V", -- Often prefer line-wise for whole classes
			},
			include_surrounding_whitespace = true,
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]]"] = "@class.outer",
				["]m"] = "@function.outer",
				["]l"] = "@loop.outer",
				["]i"] = "@conditional.outer",
			},
			goto_previous_start = {
				["[["] = "@class.outer",
				["[m"] = "@function.outer",
				["[l"] = "@loop.outer", -- Jump to previous loop
				["[i"] = "@conditional.outer", -- Jump to previous conditional
				["[r"] = "@return.outer", -- Jump to previous return statement
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>sp"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>sP"] = "@parameter.inner",
			},
		},
	},
}
