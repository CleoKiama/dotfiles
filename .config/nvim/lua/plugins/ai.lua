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
		"NickvanDyke/opencode.nvim",
		init = function()
			-- Must be set before plugin loads
			vim.g.opencode_opts = {
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
					require("opencode").ask(" ", {
						submit = false,
					})
				end,
				desc = "Ask (freeform).Don't auto submit",
				mode = { "n", "x" },
			},
			{
				"<leader>ao",
				function()
					require("opencode").select()
				end,
				desc = "Select prompt (auto-submit)",
				mode = { "n", "x" },
			},
			{
				"<leader>as",
				function()
					require("opencode").command("prompt.submit")
				end,
				desc = "Opencode prompt submit",
				mode = { "n" },
			},
			{
				"<C-x>u",
				function()
					require("opencode").command("session.half.page.up")
				end,
				desc = "Scroll opencode up",
				mode = { "n" },
			},
			{
				"<C-x>d",
				function()
					require("opencode").command("session.half.page.down")
				end,
				desc = "Scroll opencode down",
				mode = { "n" },
			},
		},
	},
}
