require("lint").linters_by_ft = {
  markdown = { "cspell", "write_good" },
  javascript = { "cspell", "biomejs" },
  typescript = { "cspell", "biomejs" },
  typescriptreact = { "biomejs", "cspell" },
  javascripttreact = { "biomejs", "cspell" },
  css = { "biomejs", "cspell" },
  html = { "biomejs", "cspell" },
  json = { "cspell", "biomejs" },
  lua = { "cspell" },
  python = { "cspell" },
  elixir = { "cspell" },
  gleam = { "cspell" },
  gitcommit = { "gitlint" }, -- Add more file types as needed
}
-- TODO
-- FIXMe
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- Run the linters defined in `linters_by_ft` for the current filetype
    require("lint").try_lint()
  end,
  pattern = {
    "*.md",
    "*.js",
    "*.ts",
    "*.tsx",
    "*.html",
    "*.mdx",
    "*.scss",
    "*.css",
    "*.jsx",
    "*.json",
    "*.lua",
    "*.ex",
    "*.heex",
  }, -- Add more file types as needed
})
