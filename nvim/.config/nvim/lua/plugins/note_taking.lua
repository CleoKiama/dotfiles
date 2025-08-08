return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "Avante", "codecompanion" },
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"BufReadPre "
				.. vim.g.vault_root_path
				.. "**.md",
			"BufNewFile " .. vim.g.vault_root_path .. "**.md",
			"BufWritePost " .. vim.g.vault_root_path .. "**.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"3rd/image.nvim",
		},
		config = function()
			vim.cmd("set conceallevel=2")
			require("configs.obsidian")
		end,
	},
	{
		"3rd/image.nvim",
		ft = { "png", "jpg", "jpeg", "gif" },
		config = function()
			require("configs.image_nvim")
		end,
	},
	{
		"hamidi-dev/org-list.nvim",
		dependencies = {
			"tpope/vim-repeat", -- for repeatable actions with '.'
		},
		config = function()
			require("org-list").setup({
				mapping = {
					key = "<leader>lt", -- nvim-orgmode users: you might want to change this to <leader>olt
					desc = "Toggle: Cycle through list types",
				},
				checkbox_toggle = {
					enabled = true,
					-- NOTE: for nvim-orgmode users, you should change the following mapping OR change the one from orgmode.
					-- If both mapping stay the same, the one from nvim-orgmode will "win"
					key = "<C-Space>",
					desc = "Toggle checkbox state",
					filetypes = { "markdown" },
				},
			})
		end,
	},
}
