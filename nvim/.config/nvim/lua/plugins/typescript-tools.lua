return {
	{
		"pmizio/typescript-tools.nvim",
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("configs.js_ts_snippets")
			local lsp = require("configs.lspconfig")
			local navic = require("nvim-navic")
			require("typescript-tools").setup({
				on_attach = function(client, bufnr)
					lsp.on_attach(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = lsp.capabilities,
				settings = {
					tsserver_max_memory = "auto", -- or a higher number like "2048"
					-- For better performance in large projects
					separate_diagnostic_server = false,
					-- Compromise settings that work for most projects
					tsserver_file_preferences = {
						importModuleSpecifierPreference = "auto",
						importModuleSpecifierEnding = "auto",
					},
				},
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern("tsconfig.json", "package.json")(fname)
				end,
			})
		end,
	},
}
