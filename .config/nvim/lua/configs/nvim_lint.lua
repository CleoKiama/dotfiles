local function is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function has_eslint_config()
  local eslint_configs = {
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    ".eslintrc", -- plain JSON without extension
  }

  for _, config in ipairs(eslint_configs) do
    if vim.fn.filereadable(config) == 1 then
      return true
    end
  end
  return false
end

local primary_linter_cache = nil

local function select_linters_for_js_ts()
  -- Check cache first
  if primary_linter_cache then
    return { primary_linter_cache, "cspell" }
  end

  -- Check for ESLint first
  if is_executable "eslint" and has_eslint_config() then
    primary_linter_cache = "eslint"
    vim.notify("using linter: eslint", vim.log.levels.INFO)
  -- Fall back to Biome if available
  elseif is_executable "biome" then
    vim.notify("using linter: biomejs", vim.log.levels.INFO)
    primary_linter_cache = "biomejs"
  end

  return { primary_linter_cache, "cspell" }
end

require("lint").linters_by_ft = {
  markdown = { "cspell", "write_good" },
  javascript = select_linters_for_js_ts(),
  typescript = select_linters_for_js_ts(),
  typescriptreact = select_linters_for_js_ts(),
  javascriptreact = select_linters_for_js_ts(),
  css = { "biomejs", "cspell", "stylelint" },
  html = { "biomejs", "cspell" },
  json = { "cspell", "biomejs", "jsonlint" },
  lua = { "cspell" },
  python = { "cspell" },
  elixir = { "cspell", "credo" },
  gleam = { "cspell" },
  dotenv = { "cspell", "dotenv_linter" },
  gitcommit = { "gitlint" },
  go = { "cspell" },
  rust = { "cspell" },
}

local js_ts_patterns = {
  "*.js",
  "*.ts",
  "*.tsx",
  "*.jsx",
}

-- Create a table of other file patterns
local other_patterns = {
  "*.md",
  "*.html",
  "*.mdx",
  "*.scss",
  "*.css",
  "*.json",
  "*.lua",
  "*.ex",
  "*.heex",
  "*.go",
  "*.rs",
}

local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

-- Run linters on InsertLeave for JS/TS files only
vim.api.nvim_create_autocmd("BufWritePre", {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
  pattern = js_ts_patterns,
})

-- Run linters on BufWritePost for all files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
  pattern = other_patterns,
})
