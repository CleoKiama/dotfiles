return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		enabled = true,
		event = "InsertEnter",
		config = function()
			require("configs.copilot")
		end,
	},
	{
		"folke/sidekick.nvim",
		enabled = true,
		event = "InsertEnter",
		opts = {
			-- add any options here
		},
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<localleader>aa",
				function()
					require("sidekick.cli").toggle({ focus = true })
				end,
				desc = "Sidekick Toggle CLI",
				mode = { "n", "v" },
			},
			{
				"<localleader>ao",
				function()
					require("sidekick.cli").toggle({ name = "opencode", focus = true })
				end,
				desc = "Sidekick Claude Toggle",
				mode = { "n", "v" },
			},
		},
	},
	{
		"NickvanDyke/opencode.nvim",
		---@type opencode.Opts
		opts = {
			-- Your configuration, if any — see lua/opencode/config.lua
		},
		config = function()
			-- Listen for opencode events
			vim.api.nvim_create_autocmd("User", {
				pattern = "OpencodeEvent",
				callback = function(args)
					-- Do something interesting, like show a notification when opencode finishes responding
					if args.data.type == "session.idle" then
						vim.notify("opencode finished responding")
					end
				end,
			})
		end,
		keys = {
			-- General ask commands
			{
				"<leader>aa",
				function()
					require("opencode").ask()
				end,
				desc = "Ask (freeform)",
			},
			{
				"<leader>ac",
				function()
					require("opencode").ask("@cursor: ")
				end,
				desc = "Ask about cursor",
				mode = "n",
			},
			{
				"<leader>as",
				function()
					require("opencode").ask("@selection: ")
				end,
				desc = "Ask about selection",
				mode = "v",
			},

			-- Session management
			{
				"<leader>an",
				function()
					require("opencode").command("session_new")
				end,
				desc = "New session",
			},

			-- Output & prompts
			{
				"<leader>ap",
				function()
					require("opencode").select_prompt()
				end,
				desc = "Select prompt",
				mode = { "n", "v" },
			},
			{
				"<leader>ae",
				function()
					require("opencode").prompt("Explain @cursor")
				end,
				desc = "Explain code near cursor",
			},

			-- Messages
			{
				"<leader>ay",
				function()
					require("opencode").command("messages_copy")
				end,
				desc = "Copy last message",
			},
			{
				"<S-C-u>",
				function()
					require("opencode").command("messages_half_page_up")
				end,
				desc = "Scroll messages up",
			},
			{
				"<S-C-d>",
				function()
					require("opencode").command("messages_half_page_down")
				end,
				desc = "Scroll messages down",
			},

			-- Toggle
			{
				"<leader>at",
				function()
					require("opencode").toggle()
				end,
				desc = "Toggle embedded opencode",
			},
		},
	},
}
