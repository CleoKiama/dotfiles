return {
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		ft = { "html", "javascriptreact", "typescriptreact", "heex" },
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"onsails/lspkind.nvim",
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			require("configs.tailwind_tools")
		end,
		opts = {}, -- your configuration
	},
}
