local map = vim.keymap.set

-- oil.nvim
map("n", "-", "<CMD>Oil<CR>", { desc = "[p] Open parent directory" })

-- winresizer
map("n", "<leader>e", "<CMD>WinResizerStartResize<CR>", { desc = "[p] Start window resize" })

-- Neotest keybindings
map("n", "<leader>tr", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "[p] Run current file" })

map("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "[p] Debug nearest test" })

map("n", "<leader>tS", function()
	require("neotest").run.stop()
end, { desc = "[p] Stop nearest test" })

map("n", "<leader>ta", function()
	require("neotest").run.attach()
end, { desc = "[p] Attach to nearest test" })

map("n", "<leader>to", function()
	require("neotest").output.open({ enter = true })
end, { desc = "[p] Open output window" })

map("n", "<leader>tw", function()
	require("neotest").output.toggle()
end, { desc = "[p] Toggle output window" })

map("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, { desc = "[p] Show test summary" })

-- dap key mappings
map("n", "<leader>dr", function()
	require("dapui").setup()
	require("dap").continue()
end, { desc = "[p] DAP continue" })

map("n", "<leader>db", function()
	require("dapui").setup()
	require("dap").toggle_breakpoint()
end, { desc = "[p] DAP toggle breakpoint" })

-- tmux navigate keys
map({ "n" }, "<c-h>", "<cmd> TmuxNavigateLeft<Cr>", { desc = "[p] Tmux navigate left" })
map({ "n" }, "<c-j>", "<cmd> TmuxNavigateDown<Cr>", { desc = "[p] Tmux navigate Down" })
map({ "n" }, "<c-k>", "<cmd> TmuxNavigateUp<Cr>", { desc = "[p] Tmux navigate Up" })
map({ "n" }, "<c-l>", "<cmd> TmuxNavigateRight<Cr>", { desc = "[p] Tmux navigate Right" })

--The primeagen helpful keymaps
map("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "[p] Yank to clipboard" })
map("v", "<leader>y", '"+y', { noremap = true, silent = true })
map("n", "n", "nzzzv", { desc = "[p] Move to next search item and center it" })
map("x", "<leader>p", '"_dp', { noremap = true, silent = true, desc = "[p] Paste without yanking" })
map("n", "J", "mzJ`z", { noremap = true, silent = true, desc = "[p] Join lines and keep cursor position" })
map("n", "<leader>sf", "<cmd>normal! ggVG<CR>", { noremap = true, silent = true, desc = "[p] Select whole file" })
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "[p] Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "[p] Scroll up and center" })

-- Code Runner
map("n", "<leader>cr", ":RunCode<CR>", { desc = "[p] Run code" })

-- Trouble.nvim
map("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "[p] Diagnostics (Trouble)" })

-- Todo comments
map("n", "<leader>tt", "<cmd>TodoTrouble<CR>", { desc = "[p] Search TODO comments" })

-- vim dadbob ui
map("n", "<leader>du", "<cmd>DBUIToggle<CR>", { desc = "[p] Toggle DBUI" })

-- diffview.nvim
map("n", "<leader>dh", "<cmd>:DiffviewFileHistory %<CR>", { desc = "[p] TagbarToggle" })

-- tailwind tools
map("n", "<leader>tlc", "<cmd>Telescope tailwind classes<CR>", { desc = "[p] Telescope tailwind classes picker" })
map("n", "<leader>tlu", "<cmd>Telescope tailwind utilities<CR>", { desc = "[p] Telescope tailwind utilities picker" })
map("n", "<leader>tls", "<cmd>TailwindSort<CR>", { desc = "[p] Tailwind classes sort" })
map("v", "<leader>tls", "<cmd>TailwindSortSelection<CR>", { desc = "[p] Tailwind classes sort" })
map("n", "<leader>tlf", "<cmd>TailwindConcealToggle<CR>", { desc = "[p] toggle tailwind fold classes" })

-- Neogit
map("n", "<leader>gs", function()
	require("neogit").open()
	require("custom.commit_hook")
end, { desc = "[p] git status" })

map("n", "<leader>gc", function()
	require("neogit").open({ "commit" })
	require("custom.commit_hook")
end, { desc = "[p] git commit" })

map("n", "<leader>gP", function()
	require("neogit").open({ "push" })
end, { desc = "[p] git push" })

map("n", "<leader>gp", function()
	require("neogit").open({ "pull" })
end, { desc = "[p] git pull" })

-- iron repl
map("n", "<space>rs", "<cmd>IronRepl<cr>", {})
map("n", "<space>rr", "<cmd>IronRestart<cr>")
map("n", "<space>rf", "<cmd>IronFocus<cr>")
map("n", "<space>rt", "<cmd>IronHide<cr>")

-- Leet code
map("n", "<localleader>lm", "<cmd>Leet<CR>", { desc = "[p] open Leet menu/dashboard" })
map("n", "<localleader>lr", "<cmd>Leet run<CR>", { desc = "[p] Leet code run" })
map("n", "<localleader>ls", "<cmd>Leet submit<CR>", { desc = "[p] Leet code submit" })
map("n", "<localleader>le", "<cmd>Leet exit<CR>", { desc = "[p] Leet exit" })
map("n", "<localleader>lc", "<cmd>Leet console<CR>", { desc = "[p] Leet console" })
map("n", "<localleader>lp", "<cmd>Leet last_submit<CR>", { desc = "[p] Leet code last_submit" })
map("n", "<localleader>li", "<cmd>Leet info<CR>", { desc = "[p] Leet code info" })
map("n", "<localleader>lo", "<cmd>Leet open<CR>", { desc = "[p] leet open in browser" })

-- Tstools
-- Sort and remove unused imports
map("n", "<localleader>to", "<cmd>TSToolsOrganizeImports<CR>", { desc = "[p] Organize and remove unused imports" })

map("n", "<localleader>tsi", "<cmd>TSToolsSortImports<CR>", { desc = "[p] Sort imports" })

map("n", "<localleader>tri", "<cmd>TSToolsRemoveUnusedImports<CR>", { desc = "[p] Remove unused imports" })

map("n", "<localleader>tru", "<cmd>TSToolsRemoveUnused<CR>", { desc = "[p] Remove all unused statements" })

map("n", "<localleader>tam", "<cmd>TSToolsAddMissingImports<CR>", { desc = "[p] Add missing imports" })

map("n", "<localleader>tfa", "<cmd>TSToolsFixAll<CR>", { desc = "[p] Fix all errors" })

map("n", "<localleader>tsd", "<cmd>TSToolsGoToSourceDefinition<CR>", { desc = "[p] Go to source definition" })

map("n", "<localleader>trf", "<cmd>TSToolsRenameFile<CR>", { desc = "[p] Rename file and update references" })

map("n", "<localleader>tfr", "<cmd>TSToolsFileReferences<CR>", { desc = "[p] Find file references" })

map("n", "<leader>nn", "<cmd>set nu!<CR>", { desc = "[p] Toggle line number" })

-- plugin dev mappings
map("n", "<localleader>rf", "<cmd>source % <CR>", { desc = "[p] run current File" })

-- Convert filepath to module name
-- e.g. /home/user/.config/nvim/lua/mymodule.lua -> mymodule
local function get_current_module_name()
	local filepath = vim.fn.expand("%:p")
	-- Get everything after /lua/ directory
	local module = filepath:match("/lua/(.+)$")
	if module then
		-- Remove .lua extension and convert / to .
		return module:gsub("%.lua$", ""):gsub("/", ".")
	end
end

-- Create the mapping
map("n", "<localleader>rl", function()
	local module_name = get_current_module_name()
	if module_name then
		R(module_name)
		print("Reloaded module: " .. module_name)
	else
		print("Not a valid lua module path")
	end
end, { desc = "[p] Reload current lua file as module" })

P = function(v)
	print(vim.inspect(v))
	return v
end
RELOAD = function(...)
	return require("plenary.reload").reload_module(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end
