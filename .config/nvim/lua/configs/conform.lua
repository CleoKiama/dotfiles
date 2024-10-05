local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "biome", "prettier" },
    html = { "biome", "prettier" },
    typescript = { "biome", "prettier", stop_after_first = true },
    typescriptreact = { "biome", "prettier", stop_after_first = true },
    javascripttreact = { "biome", "prettier", stop_after_first = true },
    javascipt = { "biome", "prettier", stop_after_first = true },
    jsx = { "biome", "prettier", stop_after_first = true },
    json = { "biome", "prettier" },
    yaml = { "prettier" },
    graphql = { "prettier" },
    markdown = { "prettier" },
    elixir = { "lsp" },
    gleam = { "lsp" },
    sql = { "sql_formatter" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
