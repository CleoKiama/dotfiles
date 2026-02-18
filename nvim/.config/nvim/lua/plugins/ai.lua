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
		enabled = false,
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
		init = function()
			-- Must be set before plugin loads
			vim.g.opencode_opts = {
				provider = {
					enabled = "tmux",
					tmux = {
						options = "-h",
						focus = false,
						allow_passthrough = false,
					},
				},
				prompts = {
					ask_auto = { prompt = "", ask = true, submit = true },
					ask_this = { prompt = "@this: ", ask = true, submit = true },
					explain = { prompt = "Explain @this", submit = true },
					fix = { prompt = "Fix @diagnostics", submit = true },
					review = { prompt = "Review @this for correctness and readability", submit = true },
					document = { prompt = "Add comments documenting @this", submit = true },
					optimize = { prompt = "Optimize @this for performance and readability", submit = true },
					test = { prompt = "Add tests for @this", submit = true },
				},
			}
		end,
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
					require("opencode").ask("@this: ", {
						submit = true,
					})
				end,
				desc = "Ask (freeform)",
				mode = { "n", "x" },
			},
			{
				"<leader>aq",
				function()
					require("opencode").ask("@this: ", {
						submit = false,
					})
				end,
				desc = "Ask (freeform).Don't auto submit",
				mode = { "n", "x" },
			},
			{
				"<leader>as",
				function()
					require("opencode").select()
				end,
				desc = "Select prompt (auto-submit)",
				mode = { "n", "x" },
			},
			{
				"go",
				function()
					return require("opencode").operator("@this ")
				end,
				desc = "Add range to opencode",
				mode = { "n", "x" },
			},
			{
				"goo",
				function()
					return require("opencode").operator("@this ") .. "_"
				end,
				desc = "Add line to opencode",
				mode = { "n", "x" },
			},
			{
				"<S-C-u>",
				function()
					require("opencode").command("session.half.page.up")
				end,
				desc = "Scroll opencode up",
				mode = { "n" },
			},
			{
				"<S-C-d>",
				function()
					require("opencode").command("session.half.page.down")
				end,
				desc = "Scroll opencode down",
				mode = { "n" },
			},
		},
	},
}
