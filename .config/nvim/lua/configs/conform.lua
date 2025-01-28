local function has_prettier_config()
  local prettier_files = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettier.config.js",
    "prettier.config.js",
    "prettier.config.mjs",
  }

  for _, file in ipairs(prettier_files) do
    if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
      return true
    end
  end
  return false
end

local function get_js_formatter()
  if has_prettier_config() then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    typescript = get_js_formatter(),
    typescriptreact = get_js_formatter(),
    javascriptreact = get_js_formatter(),
    javascript = get_js_formatter(),
    jsx = get_js_formatter(),
    json = get_js_formatter(),
    yaml = { "prettier" },
    graphql = { "prettier" },
    markdown = { "prettier" },
    elixir = { "lsp" },
    gleam = { "lsp" },
    sql = { "sql_formatter" },
    bash = { "beautysh" },
    go = { "goimports", "lsp" },
    rust = { "rustfmt" },
  },
}

require("conform").setup(options)

---format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf }
  end,
})
