-- INFO: custom lsp breadcrumbs in winbar
-- https://github.com/juniorsundar/nvim/blob/534554a50cc468df0901dc3861e7325a54c01457/lua/config/lsp/breadcrumbs.lua

local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
local folder_icon = "%#Conditional#" .. "󰉋" .. "%#Normal#"
local file_icon = "󰈙"

local kind_icons = {
	"%#File#" .. "󰈙" .. "%#Normal#", -- file
	"%#Module#" .. "" .. "%#Normal#", -- module
	"%#Structure#" .. "" .. "%#Normal#", -- namespace
	"%#Keyword#" .. "󰌋" .. "%#Normal#", -- key
	"%#Class#" .. "󰠱" .. "%#Normal#", -- class
	"%#Method#" .. "󰆧" .. "%#Normal#", -- method
	"%#Property#" .. "󰜢" .. "%#Normal#", -- property
	"%#Field#" .. "󰇽" .. "%#Normal#", -- field
	"%#Function#" .. "" .. "%#Normal#", -- constructor
	"%#Enum#" .. "" .. "%#Normal#", -- enum
	"%#Type#" .. "" .. "%#Normal#", -- interface
	"%#Function#" .. "󰊕" .. "%#Normal#", -- function
	"%#None#" .. "󰂡" .. "%#Normal#", -- variable
	"%#Constant#" .. "󰏿" .. "%#Normal#", -- constant
	"%#String#" .. "" .. "%#Normal#", -- string
	"%#Number#" .. "" .. "%#Normal#", -- number
	"%#Boolean#" .. "" .. "%#Normal#", -- boolean
	"%#Array#" .. "" .. "%#Normal#", -- array
	"%#Class#" .. "" .. "%#Normal#", -- object
	"", -- package
	"󰟢", -- null
	"", -- enum-member
	"%#Struct#" .. "" .. "%#Normal#", -- struct
	"", -- event
	"", -- operator
	"󰅲", -- type-parameter
}

local function range_contains_pos(symbol, line, char)
	local range = symbol.range or (symbol.location and symbol.location.range) -- some servers use location.range like the html server
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

local function find_symbol_path(symbol_list, line, char, path)
	if not symbol_list or #symbol_list == 0 then
		return false
	end
	for _, symbol in ipairs(symbol_list) do
		if range_contains_pos(symbol, line, char) then
			local icon = kind_icons[symbol.kind] or ""
			table.insert(path, icon .. " " .. symbol.name)
			find_symbol_path(symbol.children, line, char, path)
			return true
		end
	end
	return false
end

--- @param err table | nil
local function lsp_callback(err, symbols, ctx)
	if err or not symbols then
		vim.o.winbar = ""
		return
	end

	local winnr = vim.api.nvim_get_current_win()
	local pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = pos[1] - 1 -- LSP uses 0-based line numbers
	local cursor_char = pos[2] -- this is 0 based already

	local file_path = vim.fn.bufname(ctx.bufnr)
	if not file_path or file_path == "[No Name]" or file_path == "" then
		vim.o.winbar = "[No Name]"
		return
	end

	local relative_path

	local clients = vim.lsp.get_clients({ bufnr = ctx.bufnr })

	if #clients > 0 and clients[1].root_dir then
		local root_dir = clients[1].root_dir
		if root_dir == nil then
			relative_path = file_path
		else
			relative_path = vim.fs.relpath(root_dir, file_path)
		end
	else
		local root_dir = vim.fn.getcwd(0)
		relative_path = vim.fs.relpath(root_dir, file_path)
	end

	local breadcrumbs = {}

	local path_components = vim.split(relative_path or " ", "/", { trimempty = true })
	local num_components = #path_components

	for i, component in ipairs(path_components) do
		if i == num_components then
			local icon
			local icon_hl

			if devicons_ok then
				icon, icon_hl = devicons.get_icon(component)
			end
			table.insert(breadcrumbs, "%#" .. icon_hl .. "#" .. (icon or file_icon) .. "%#Normal#" .. " " .. component)
		else
			table.insert(breadcrumbs, folder_icon .. " " .. component)
		end
	end
	find_symbol_path(symbols, cursor_line, cursor_char, breadcrumbs)

	local breadcrumb_string = table.concat(breadcrumbs, " > ")

	if breadcrumb_string ~= "" then
		vim.api.nvim_set_option_value("winbar", breadcrumb_string, { win = winnr })
	else
		vim.api.nvim_set_option_value("winbar", " ", { win = winnr })
	end
end

--- @param clients vim.lsp.Client[]
--- @param bufnr integer
---@return vim.lsp.Client?
local function text_symbol_supported_clients(clients, bufnr)
	for _, client in ipairs(clients) do
		if client.supports_method("textDocument/documentSymbol", bufnr) then
			return client
		end
	end
	return nil
end

local function breadcrumbs_set()
	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local supported_client = text_symbol_supported_clients(clients, bufnr)
	if not supported_client then
		return
	end

	local uri = vim.lsp.util.make_text_document_params(bufnr).uri
	if not uri then
		vim.notify("Error: Could not get URI for buffer. Is it saved?", vim.logs.levels.WARN)
		return
	end

	local params = {
		textDocument = {
			uri = uri,
		},
	}

	local buf_src = uri:sub(1, uri:find(":") - 1)
	-- if the buffer is not a file, clear the winbar and return
	if buf_src ~= "file" then
		vim.o.winbar = ""
		return
	end

	local result, _ = pcall(supported_client.request, "textDocument/documentSymbol", params, lsp_callback, bufnr)
	if not result then
		return
	end
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

local function debounce_breadcrumbs()
	local timer = vim.uv.new_timer()
	local debounce_interval = 200

	return function()
		timer:stop() -- Stop existing timer if running
		timer:start(
			debounce_interval,
			0,
			vim.schedule_wrap(function()
				breadcrumbs_set()
			end)
		)
	end
end
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
	group = breadcrumbs_augroup,
	callback = debounce_breadcrumbs(),
	desc = "Set breadcrumbs.",
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = breadcrumbs_augroup,
	callback = function()
		vim.o.winbar = ""
	end,
	desc = "Clear breadcrumbs when leaving window.",
})
