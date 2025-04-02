-- removing space from triggerCharacters can significantly improves performance
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		for _, client in pairs((vim.lsp.get_clients({}))) do
			if client.name == "tailwindcss" then
				client.server_capabilities.completionProvider.triggerCharacters =
					{ '"', "'", "`", ".", "(", "[", "!", "/", ":" }
			end
		end
	end,
})

require("tailwind-tools.cmp")
local lsp = require("configs.lspconfig")

require("tailwind-tools").setup({
	document_color = {
		enabled = false, -- can be toggled by commands
		kind = "inline", -- "inline" | "foreground" | "background"
		inline_symbol = "󰝤 ", -- only used in inline mode
		debounce = 200, -- in milliseconds, only applied in insert mode
	},
	conceal = {
		enabled = false, -- can be toggled by commands
		min_length = nil, -- only conceal classes exceeding the provided length
		symbol = "󱏿", -- only a single character is allowed
		highlight = { -- extmark highlight options, see :h 'highlight'
			fg = "#38BDF8",
		},
	},
	server = {
		override = true, -- setup the server from the plugin if true
		settings = {}, -- shortcut for `settings.tailwindCSS`
		on_attach = function(client, bufnr)
			lsp.on_attach(client, bufnr)
		end,
	},
	cmp = {
		highlight = "foreground", -- color preview style, "foreground" | "background"
	},
	telescope = {
		utilities = {
			-- the function used when selecting an utility class in telescope
			callback = function(name, class) end,
		},
	},
	-- see the extension section to learn more
	extension = {
		queries = {}, -- a list of filetypes having custom `class` queries
		patterns = { -- a map of filetypes to Lua pattern lists
			-- exmaple:
			-- rust = { "class=[\"']([^\"']+)[\"']" },
			-- javascript = { "clsx%(([^)]+)%)" },
		},
	},
})
