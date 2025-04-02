-- lua/configs/lspconfig.lua
local M = {}
local map = vim.keymap.set
local navic = require("nvim-navic")
local lspconfig = require("lspconfig")

-- Add Mason binaries to PATH
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- Common attach function for all LSP servers
M.on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP: " .. desc }
	end

	-- Key mappings
	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	map("n", "gr", vim.lsp.buf.references, opts("Show references"))
	map("n", "K", vim.lsp.buf.hover, opts("Show hover documentation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))
	map("n", "<leader>ra", function()
		require("nvchad.lsp.renamer")()
	end, { desc = "Rename symbol" })
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))

	-- Workspace folder management
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("List workspace folders"))

	-- Add navic attachment
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
end

-- Disable semantic tokens (optional)
M.on_init = function(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.capabilities = require("blink.cmp").get_lsp_capabilities()

-- Setup default configurations
M.setup = function()
	-- Configure lua_ls with some defaults
	lspconfig.lua_ls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		on_init = M.on_init,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						vim.fn.expand("$VIMRUNTIME/lua"),
						vim.fn.stdpath("config") .. "/lua",
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	})

	-- Setup additional servers
	local servers = {
		"html",
		"cssls",
		"bashls",
		"marksman",
		"prismals",
		"sqlls",
		"gleam",
		"jsonls",
	}

	for _, server in ipairs(servers) do
		lspconfig[server].setup({
			on_attach = function(client, bufnr)
				M.on_attach(client, bufnr)
				navic.attach(client, bufnr)
			end,
			capabilities = M.capabilities,
			on_init = M.on_init,
		})
	end

	-- Configure harper_ls for Obsidian vault markdown files only
	lspconfig.harper_ls.setup({
		filetypes = { "markdown" },
		root_dir = function(fname)
			-- Only activate on markdown files in the Obsidian vault
			if string.match(fname, "^/media/Library/obsidian%-vaults/.+%.md$") then
				return fname:match("(/media/Library/obsidian%-vaults/.+)/")
			end
			return nil
		end,
		on_attach = M.on_attach,
		on_init = M.on_init,
		capabilities = M.capabilities,
		settings = {
			["harper-ls"] = {
				linters = {
					SpellCheck = true,
					SpelledNumbers = false,
					AnA = true,
					SentenceCapitalization = true,
					UnclosedQuotes = true,
					WrongQuotes = false,
					LongSentences = true,
					RepeatedWords = true,
					Spaces = true,
					Matcher = true,
					CorrectNumberSuffix = true,
				},
				diagnosticSeverity = "hint",
				markdown = {
					IgnoreLinkTitle = false,
				},
			},
		},
	})
end

return M
