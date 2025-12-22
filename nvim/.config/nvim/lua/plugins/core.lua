return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = function()
			dofile(vim.g.base46_cache .. "devicons")
			return { override = require("nvchad.icons.devicons") }
		end,
	},
	"nvim-lua/plenary.nvim",
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = { history = true, updateevents = "TextChanged,TextChangedI" },
		config = function(_, opts)
			require("luasnip").config.set_config(opts)
			require("configs.luasnip")
		end,
	},
	{
		"nvchad/ui",
		lazy = false,
		priority = 1000,
		config = function()
			require("nvchad")
		end,
	},
	{
		"nvchad/base46",
		build = function()
			require("base46").load_all_highlights()
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			return require("configs.nvimtree")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
		branch = "main",
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable" },
		build = ":TSUpdate",
		config = function(_, opts)
			-- setup nvchad staff
			dofile(vim.g.base46_cache .. "treesitter")
			dofile(vim.g.base46_cache .. "syntax")
			local ts_configs = require("configs.treesitter")

			-- replicate `ensure_installed`, runs asynchronously, skips existing languages
			-- require("nvim-treesitter").install(ts_configs.ensure_installed)
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter.setup", {}),
				callback = function(args)
					local buf = args.buf
					local filetype = args.match

					-- you need some mechanism to avoid running on buffers that do not
					-- correspond to a language (like oil.nvim buffers), this implementation
					-- checks if a parser exists for the current language
					local language = vim.treesitter.language.get_lang(filetype) or filetype
					if not vim.treesitter.language.add(language) then
						return
					end

					-- replicate `fold = { enable = true }`
					-- vim.wo.foldmethod = "expr"
					-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

					-- replicate `highlight = { enable = true }`
					vim.treesitter.start(buf, language)

					-- replicate `indent = { enable = true }`
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = true,
				},
				swap = {
					enable = true,
				},
				move = {
					enable = true,
					set_jumps = true,
				},
			})
		end,
		keys = {
			-- move
			{
				"]m",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
				end,
				desc = "Go to next function start",
				mode = { "n", "x", "o" },
			},

			{
				"]]",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
				end,
				desc = "Go to next class start",
				mode = { "n", "x", "o" },
			},

			{
				"]o",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						{ "@loop.inner", "@loop.outer" },
						"textobjects"
					)
				end,
				desc = "Go to next loop start",
				mode = { "n", "x", "o" },
			},
			{
				"]z",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
				end,
				desc = "Go to next fold start",
				mode = { "n", "x", "o" },
			},
			{
				"]M",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
				end,
				desc = "Go to next function end",
				mode = { "n", "x", "o" },
			},
			{
				"][",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
				end,
				desc = "Go to next class end",
				mode = { "n", "x", "o" },
			},

			{
				"[m",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
				end,
				desc = "Go to previous function start",
				mode = { "n", "x", "o" },
			},
			{
				"[[",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
				end,
				desc = "Go to previous class start",
				mode = { "n", "x", "o" },
			},
			{
				"[M",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
				end,
				desc = "Go to previous function end",
				mode = { "n", "x", "o" },
			},
			{
				"[]",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
				end,
				desc = "Go to previous class end",
				mode = { "n", "x", "o" },
			},

			-- swap
			{
				"<leader>sp",
				function()
					require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
				end,
				desc = "Swap parameter with next",
				mode = "n",
			},
			{
				"<leader>sP",
				function()
					require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
				end,
				desc = "Swap parameter with previous",
				mode = "n",
			},
		},
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>", -- start selection
						node_incremental = "<C-space>", -- expand node
						node_decremental = "<leader><S-space>", -- shrink node selection
						-- scope_incremental = "<leader>v", -- expand to scope
					},
				},
			})
		end,
		opts = {
			fold = { enable = true },
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = { enable = true },
		},
	},
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = function()
			dofile(vim.g.base46_cache .. "mason")
			require("mason").setup({
				PATH = "skip", -- Since you're handling PATH yourself
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		config = function()
			require("configs.lspconfig").setup()
			dofile(vim.g.base46_cache .. "lsp")
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("configs.conform")
		end,
	},
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g", "," },
		cmd = "WhichKey",
	},
}
