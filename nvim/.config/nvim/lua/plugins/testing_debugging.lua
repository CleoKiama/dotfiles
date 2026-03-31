return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufWritePre" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					require("none-ls.diagnostics.eslint_d"),
					require("none-ls.code_actions.eslint_d"),
				},
			})
		end,
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
	},
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			require("configs.dap")
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-jest",
			"fredrikaverpil/neotest-golang",
			"marilari88/neotest-vitest",
		},
		config = function()
			require("configs.neotest")
		end,
	},
	{
		"vim-test/vim-test",
		dependencies = { "preservim/vimux" },
		cmd = { "TestFile", "TestLast", "TestNearest", "TestSuite", "TestVisit" },
		init = function()
			-- Equivalent to: let test#rust#cargotest#test_options = '-- --nocapture'
			vim.g["test#rust#cargotest#test_options"] = "-- --show-output"

			-- Equivalent to: let test#strategy = "dispatch"
			vim.g["test#strategy"] = "vimux"

			-- Optional: limit loaded runners (if you want to lazy-load specific ones)
			-- only load the Rust cargo test runner
			vim.g["test#enabled_runners"] = { "rust#cargotest" }
		end,
		keys = {
			{
				"<leader>vn",
				":TestNearest<CR>",
				desc = "Run Nearest Test",
			},
			{
				"<leader>vf",
				":TestFile<CR>",
				desc = "Run Test File",
			},
			{
				"<leader>vl",
				":TestLast<CR>",
				desc = "Run Last Test",
			},
			{
				"<leader>vv",
				":TestVisit<CR>",
				desc = "Visit last test file",
			},
		},
	},
}
