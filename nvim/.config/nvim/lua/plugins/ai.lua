return {
	{
		"yetone/avante.nvim",
		build = "make",
		opts = {
			provider = "copilot", -- Recommend using Claude
			copilot = {
				-- model = "claude-3.7-sonnet",
				model = "claude-3.5-sonnet",
			},
			auto_suggestions_provider = "copilot",
			selector = {
				exclude_auto_select = { "NvimTree" },
			},
		},
		keys = {
			{
				"<leader>aa",
				function()
					require("avante.api").ask()
				end,
				desc = "Avante: ask",
				mode = { "n", "v" },
			},
			{
				"<leader>a+",
				function()
					local tree_ext = require("avante.extensions.nvim_tree")
					tree_ext.add_file()
				end,
				desc = "Select file in NvimTree",
				ft = "NvimTree",
			},
			{
				"<leader>a-",
				function()
					local tree_ext = require("avante.extensions.nvim_tree")
					tree_ext.remove_file()
				end,
				desc = "Deselect file in NvimTree",
				ft = "NvimTree",
			},
		},
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua", -- for providers='copilot'
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("configs.copilot")
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						name = "copilot",
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
							num_ctx = {
								default = 16384,
							},
							num_predict = {
								default = -1,
							},
						},
					})
				end,
			},
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)
			local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
				group = group,
				callback = function(ev)
					if ev.match == "CodeCompanionRequestStarted" then
						vim.notify("Processing request", vim.log.levels.INFO)
					end
					if ev.match == "CodeCompanionRequestFinished" then
						vim.notify("Request completed", vim.log.levels.INFO)
					end
				end,
			})
		end,
		keys = {
			{
				"<A-c>",
				"<cmd>CodeCompanionChat Toggle <CR>",
				desc = "CodeCompanionChat Toggle",
				mode = { "n", "v" },
			},
			{
				"<A-a>",
				"<cmd>CodeCompanionChat Add<cr>",
				{ desc = "CodeCompanionChat Toggle", noremap = true, silent = true },
				mode = { "v" },
			},
		},
	},
}
