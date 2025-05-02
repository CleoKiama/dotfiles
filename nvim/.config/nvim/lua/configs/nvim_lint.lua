local function is_executable(cmd)
	return vim.fn.executable(cmd) == 1
end

local function has_eslint_config()
	local eslint_configs = {
		".eslint.config.js",
		".eslint.config.ts",
		".eslintrc.js",
		".eslintrc.cjs",
		" eslint.config.js",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
		".eslintrc",
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
		return { primary_linter_cache }
	end

	-- Check for ESLint first
	if is_executable("eslint") and has_eslint_config() then
		primary_linter_cache = "eslint"
	-- Fall back to Biome if available
	elseif is_executable("biome") then
		primary_linter_cache = "biomejs"
	end

	return { primary_linter_cache, "cspell" }
end

require("lint").linters_by_ft = {
	markdown = {},
	javascript = select_linters_for_js_ts(),
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	javascriptreact = select_linters_for_js_ts(),
	css = { "biomejs", "stylelint" },
	html = { "biomejs" },
	json = { "biomejs", "jsonlint" },
	dotenv = { "dotenv_linter" },
	gitcommit = { "gitlint" },
	yaml = { "yamllint" },
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

-- Timer for debouncing
local lint_timer = nil

-- Function to handle debounced linting
local function debounced_lint()
	if lint_timer then
		lint_timer:stop()
	end
	lint_timer = vim.defer_fn(function()
		require("lint").try_lint()
	end, 3000) -- 3 second delay
end

-- Run linters on InsertLeave for JS/TS files
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	group = lint_augroup,
	callback = function()
		if vim.fn.mode() == "n" then
			debounced_lint()
		else
			require("lint").try_lint()
		end
	end,
	pattern = js_ts_patterns,
})

-- Run linters on BufWritePre for all other files
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lint_augroup,
	callback = function()
		require("lint").try_lint()
	end,
	pattern = other_patterns,
})
