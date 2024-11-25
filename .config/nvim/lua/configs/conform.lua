local js_formatter = { "biome", "prettier", stop_after_first = true }

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = js_formatter,
    html = js_formatter,
    typescript = js_formatter,
    typescriptreact = js_formatter,
    javascriptreact = js_formatter,
    javascript = js_formatter,
    jsx = js_formatter,
    json = js_formatter,
    yaml = { "prettier" },
    graphql = { "prettier" },
    markdown = { "prettier" },
    elixir = { "lsp" },
    gleam = { "lsp" },
    sql = { "sql_formatter" },
    go = { "goimports", "lsp" },
    ["*"] = { "codespell" },
  },
}

require("conform").setup(options)
-- and
---format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf }
  end,
})
