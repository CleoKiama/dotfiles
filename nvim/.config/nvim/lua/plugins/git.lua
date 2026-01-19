return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
		},
		config = true,
	},
	{ --* Git graph of branches in a git repo *--
		"isakbm/gitgraph.nvim",
		opts = {
			hooks = {
				-- Check diff of a commit (with diffview.nvim)
				on_select_commit = function(commit)
					vim.notify("DiffviewOpen " .. commit.hash .. "^!")
					vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
				end,
				-- Check diff from commit a -> commit b (with diffview.nvim)
				on_select_range_commit = function(from, to)
					vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
					vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
				end,
			},
		},
		keys = {
			{ -- Open GitGraph
				"<leader>gg",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
		keys = {
			{ "<leader>gdf", "<cmd>:CodeDiff file HEAD <CR>", { desc = "vscode-diff" } },
			{ "<leader>gda", "<cmd>:CodeDiff <CR>", { desc = "vscode-diff" } },
		},
	},
}
