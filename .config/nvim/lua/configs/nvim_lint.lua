local function is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function select_linters_for_js_ts()
  local available_linters = { "cspell" } -- Always include cspell

  -- Check for ESLint first
  if is_executable "eslint" and vim.fn.filereadable ".eslintrc.js" == 1 then
    table.insert(available_linters, 1, "eslint")
  -- Fall back to Biome if available
  elseif is_executable "biome" then
    table.insert(available_linters, 1, "biomejs")
  end

  return available_linters
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
  dotenv = { "cspell", "dotenv_linter" }, -- Assuming dotenv-linter is the linter you want to use
  gitcommit = { "gitlint" },
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
}

local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })
local lint_timeout = 1500 -- ms

local function debounced_lint()
  local timer = vim.loop.new_timer()
  return function()
    timer:start(
      lint_timeout,
      0,
      vim.schedule_wrap(function()
        require("lint").try_lint()
      end)
    )
  end
end

local lint_callback = debounced_lint()

-- Run linters on InsertLeave for JS/TS files only
vim.api.nvim_create_autocmd("InsertLeave", {
  group = lint_augroup,
  callback = lint_callback,
  pattern = js_ts_patterns,
})

-- Run linters on BufWritePost for all files
vim.api.nvim_create_autocmd("BufWritePost", {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
  pattern = other_patterns,
})
