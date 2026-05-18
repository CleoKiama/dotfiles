local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "oxfmt" },
		html = { "oxfmt" },
		typescript = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		javascript = { "oxfmt" },
		jsx = { "oxfmt" },
		json = { "oxfmt" },
		yaml = { "oxfmt" },
		graphql = { "oxfmt" },
		markdown = { "oxfmt" },
		elixir = { "lsp" },
		gleam = { "lsp" },
		sql = { "sql_formatter" },
		sh = { "beautysh" },
		python = { "black" },
		go = { "goimports" },
		rust = { "rustfmt" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 3000,
		lsp_fallback = true,
	},
}

require("conform").setup(options)

---format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
