local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

local folder_icon = "%#Conditional#" .. "󰉋" .. "%#Normal#"
local file_icon = "󰈙"

-- Cache per buffer: { symbols, base_segments, last_winbar, timer }
local buf_cache = {}

local kind_icons = {
	"%#File#" .. "󰈙" .. "%#Normal#", -- file
	"%#Module#" .. "" .. "%#Normal#", -- module
	"%#Structure#" .. "" .. "%#Normal#", -- namespace
	"%#Keyword#" .. "󰌋" .. "%#Normal#", -- key
	"%#Class#" .. "󰠱" .. "%#Normal#", -- class
	"%#Method#" .. "󰆧" .. "%#Normal#", -- method
	"%#Property#" .. "󰜢" .. "%#Normal#", -- property
	"%#Field#" .. "󰇽" .. "%#Normal#", -- field
	"%#Function#" .. "" .. "%#Normal#", -- constructor
	"%#Enum#" .. "" .. "%#Normal#", -- enum
	"%#Type#" .. "" .. "%#Normal#", -- interface
	"%#Function#" .. "󰊕" .. "%#Normal#", -- function
	"%#None#" .. "󰂡" .. "%#Normal#", -- variable
	"%#Constant#" .. "󰏿" .. "%#Normal#", -- constant
	"%#String#" .. "" .. "%#Normal#", -- string
	"%#Number#" .. "" .. "%#Normal#", -- number
	"%#Boolean#" .. "" .. "%#Normal#", -- boolean
	"%#Array#" .. "" .. "%#Normal#", -- array
	"%#Class#" .. "" .. "%#Normal#", -- object
	"", -- package
	"󰟢", -- null
	"", -- enum-member
	"%#Struct#" .. "" .. "%#Normal#", -- struct
	"", -- event
	"", -- operator
	"󰅲", -- type-parameter
}

local function range_contains_pos(range, line, char)
	local start = range.start
	local stop = range["end"]

	if line < start.line or line > stop.line then
		return false
	end

	if line == start.line and char < start.character then
		return false
	end

	if line == stop.line and char > stop.character then
		return false
	end

	return true
end

local function get_base_segments(bufnr)
	local cache = buf_cache[bufnr]
	if cache and cache.base_segments then
		return cache.base_segments
	end

	local file_path = vim.api.nvim_buf_get_name(bufnr)
	if not file_path or file_path == "" then
		return { "[No Name]" }
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local relative_path = vim.fn.fnamemodify(file_path, ":t")

	if #clients > 0 and clients[1].root_dir then
		local root_dir = clients[1].root_dir
		if root_dir then
			local rel = vim.fs.relpath(file_path, root_dir)
			if rel and rel ~= "" then
				relative_path = rel
			end
		end
	end

	local path_components = vim.split(relative_path, "[/\\]+", { trimempty = true })
	local segments = {}

	for i, component in ipairs(path_components) do
		if i == #path_components then
			local icon, icon_hl = nil, nil
			if devicons_ok then
				icon, icon_hl = devicons.get_icon(component)
			end

			local segment
			if icon and icon_hl then
				segment = "%#" .. icon_hl .. "#" .. icon .. "%#Normal# " .. component
			else
				segment = file_icon .. " " .. component
			end
			table.insert(segments, segment)
		else
			table.insert(segments, folder_icon .. " " .. component)
		end
	end

	if not buf_cache[bufnr] then
		buf_cache[bufnr] = {}
	end
	buf_cache[bufnr].base_segments = segments
	return segments
end

local function find_symbol_path(symbol_list, line, char, path)
	if not symbol_list or #symbol_list == 0 then
		return false
	end

	for _, symbol in ipairs(symbol_list) do
		if range_contains_pos(symbol.range, line, char) then
			local icon = kind_icons[symbol.kind] or ""
			table.insert(path, (icon or "") .. " " .. symbol.name)
			find_symbol_path(symbol.children, line, char, path)
			return true
		end
	end
	return false
end

local function update_winbar(bufnr)
	local cache = buf_cache[bufnr]
	if not cache or not cache.symbols then
		return
	end

	local pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = pos[1] - 1
	local cursor_char = pos[2]

	local breadcrumbs = vim.deepcopy(get_base_segments(bufnr))
	find_symbol_path(cache.symbols, cursor_line, cursor_char, breadcrumbs)

	local breadcrumb_string = table.concat(breadcrumbs, " > ")
	if breadcrumb_string == "" then
		breadcrumb_string = " "
	end

	if cache.last_winbar ~= breadcrumb_string then
		vim.wo.winbar = breadcrumb_string
		cache.last_winbar = breadcrumb_string
	end
end

local function lsp_callback(err, symbols, ctx, config)
	if err or not symbols then
		vim.wo.winbar = ""
		return
	end

	if not buf_cache[ctx.bufnr] then
		buf_cache[ctx.bufnr] = {}
	end

	buf_cache[ctx.bufnr].symbols = symbols
	update_winbar(ctx.bufnr)
end

local function refresh_symbols(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 or not clients[1].supports_method("textDocument/documentSymbol") then
		return
	end

	local uri = vim.lsp.util.make_text_document_params(bufnr)["uri"]
	if not uri then
		return
	end

	local params = {
		textDocument = { uri = uri },
	}
	vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, lsp_callback)
end

local function debounced_update()
	local bufnr = vim.api.nvim_get_current_buf()
	local cache = buf_cache[bufnr]

	if cache and cache.timer then
		cache.timer:stop()
	end

	if not cache then
		buf_cache[bufnr] = {}
		cache = buf_cache[bufnr]
	end

	cache.timer = vim.defer_fn(function()
		update_winbar(bufnr)
	end, 200)
end

-- Cleanup cache on buffer delete
vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		buf_cache[args.buf] = nil
	end,
})

-- Refresh symbols when needed
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	callback = function()
		refresh_symbols(vim.api.nvim_get_current_buf())
	end,
})

-- Update breadcrumbs on cursor move (debounced)
vim.api.nvim_create_autocmd("CursorMoved", {
	callback = debounced_update,
})
