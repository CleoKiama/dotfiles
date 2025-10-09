local M = {}
local map = vim.keymap.set
local navic = require("nvim-navic")

-- Add Mason binaries to PATH
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- Common attach function for all LSP servers
M.on_attach = function(_, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP: " .. desc }
	end

	-- Key mappings
	map("n", "gD", function()
		Snacks.picker.lsp_declarations()
	end, opts("Go to declaration"))

	map("n", "gd", function()
		Snacks.picker.lsp_definitions()
	end, opts("Go to definition"))

	map("n", "<leader>D", function()
		Snacks.picker.lsp_type_definitions()
	end, opts("Go to type definition"))

	map("n", "gi", function()
		Snacks.picker.lsp_implementations()
	end, opts("Go to implementation"))

	map("n", "gr", function()
		Snacks.picker.lsp_references()
	end, opts("Show references"))

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
	vim.lsp.config("lua_ls", {
		on_attach = function(client, bufnr)
			M.on_attach(client, bufnr)
			navic.attach(client, bufnr)
		end,
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
						vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	})

	vim.lsp.enable("lua_ls")

	-- Setup additional servers
	local servers = {
		"html",
		"cssls",
		"bashls",
		"marksman",
		"prismals",
		"postgres_lsp",
		"gleam",
		"jsonls",
		"yamlls",
		"pylsp",
		"tailwindcss",
		"copilot",
	}

	for _, server in ipairs(servers) do
		vim.lsp.config(server, {
			on_attach = function(client, bufnr)
				M.on_attach(client, bufnr)
				if client.name ~= "postgres_lsp" and client.name ~= "copilot" and client.name ~= "tailwindcss" then
					navic.attach(client, bufnr) -- postgres_lsp doesn’t support navic
				end
			end,
			capabilities = M.capabilities,
			on_init = M.on_init,
		})
		vim.lsp.enable(server)
	end

	-- Configure harper_ls for Obsidian vault markdown files only
	vim.lsp.config("harper_ls", {
		filetypes = { "markdown" },
		root_dir = function(fname)
			local vault_pattern = "^" .. vim.g.vault_path:gsub("%-", "%%-") .. "/.+%.md$"
			if string.match(fname, vault_pattern) then
				return vim.g.vault_path
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

	vim.lsp.enable("harper_ls")
end

return M
