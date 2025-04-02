local opt = vim.opt
vim.g.use_blink_cmp = true
local o = vim.o
local g = vim.g

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if
			line > 1
			and line <= vim.fn.line("$")
			and vim.bo.filetype ~= "commit"
			and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
		then
			vim.cmd('normal! g`"')
		end
	end,
})

-- custom
opt.spelllang = "en_us"
opt.spell = true

opt.hlsearch = false
opt.incsearch = true

--- neogit diff colors
vim.cmd("highlight NeogitDiffDelete guibg=#2d4f67 guifg=#c0caf5")
vim.cmd("highlight NeogitDiffDeleteHighlight guibg=#334e68 guifg=#c0caf5")

-- Configure diagnostics to show virtual text
vim.diagnostic.config({
	virtual_text = {
		-- Show the diagnostic text after the line
		prefix = "●", -- You can use icons like "●", "■", or "▎"
		spacing = 4, -- Number of spaces between the end of line and diagnostic message
		source = "if_many", -- Show source of diagnostic if there are multiple sources
	},
	-- Keep other diagnostic features enabled
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.g.use_blink_cmp = true
