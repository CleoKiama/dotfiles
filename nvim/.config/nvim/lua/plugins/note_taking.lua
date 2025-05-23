return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "Avante", "codecompanion" },
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"BufReadPre /media/Library/obsidian-vaults/**.md",
			"BufNewFile /media/Library/obsidian-vaults/**.md",
			"BufWritePost /media/Library/obsidian-vaults/**.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			-- see below for full list of optional dependencies 👇
		},
		config = function()
			vim.cmd("set conceallevel=2")
			require("configs.obsidian")
		end,
	},
	{
		"3rd/image.nvim",
		ft = { "png", "jpg", "jpeg", "gif" },
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"BufReadPre /media/Library/obsidian-vaults/**.md",
			"BufNewFile /media/Library/obsidian-vaults/**.md",
			"BufWritePost /media/Library/obsidian-vaults/**.md",
		},
		config = function()
			require("configs.image_nvim")
		end,
	},
	{
		"CleoKiama/ObsidianTracker.nvim",
		dir = "/home/cleo/plugins/ObsidianTracker.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "3rd/image.nvim" },
		opts = {
			pathToVault = "/media/Library/obsidian-vaults/10xGoals/Journal/Dailies",
		},
		keys = {
			{ "<localleader>ot", "<cmd>ToggleTracker<cr>", desc = "Obsidian Tracker" },
		},
	},
}
