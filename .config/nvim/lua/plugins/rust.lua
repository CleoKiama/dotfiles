local package_prefix = "<leader>cm"

return {
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup()
		end,
		keys = {
			{
				package_prefix .. "R",
				function()
					require("crates").reload()
				end,
				desc = "Reload",
			},

			{
				package_prefix .. "u",
				function()
					require("crates").update_crate()
				end,
				desc = "Update Create",
			},
			{
				package_prefix .. "u",
				mode = "v",
				function()
					require("crates").update_crates()
				end,
				desc = "Update Crates",
			},
			{
				package_prefix .. "a",
				function()
					require("crates").update_all_crates()
				end,
				desc = "Update All Crates",
			},

			{
				package_prefix .. "U",
				function()
					require("crates").upgrade_crate()
				end,
				desc = "Upgrade Create",
			},
			{
				package_prefix .. "U",
				mode = "v",
				function()
					require("crates").upgrade_crates()
				end,
				desc = "Upgrade Crates",
			},
			{
				package_prefix .. "A",
				function()
					require("crates").upgrade_all_crates()
				end,
				desc = "Upgrade All Crates",
			},

			{
				package_prefix .. "t",
				function()
					require("crates").expand_plain_crate_to_inline_table()
				end,
				desc = "Extract into Inline Table",
			},
			{
				package_prefix .. "T",
				function()
					require("crates").extract_crate_into_table()
				end,
				desc = "Extract into Table",
			},

			{
				package_prefix .. "h",
				function()
					require("crates").open_homepage()
				end,
				desc = "Homepage",
			},
			{
				package_prefix .. "r",
				function()
					require("crates").open_repository()
				end,
				desc = "Repo",
			},
			{
				package_prefix .. "d",
				function()
					require("crates").open_documentation()
				end,
				desc = "Documentation",
			},
			{
				package_prefix .. "c",
				function()
					require("crates").open_crates_io()
				end,
				desc = "Crates.io",
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		ft = "rust", -- only load on rust files
		config = function()
			local mason_registry = require("mason-registry")
			local codelldb = mason_registry.get_package("codelldb")
			local extension_path = codelldb:get_install_path() .. "/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
			local cfg = require("rustaceanvim.config")

			local lsp = require("configs.lspconfig")
			local navic = require("nvim-navic")

			vim.g.rustaceanvim = {
				dap = {
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
				server = {
					on_attach = function(client, bufnr)
						lsp.on_attach(client, bufnr)
						navic.attach(client, bufnr)
					end,
					capabilities = lsp.capabilities,
				},
				-- for blink cmp
				completion = {
					capable = {
						snippets = "add_parenthesis",
					},
				},
			}
		end,
	},
}
