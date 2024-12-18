require "nvchad.mappings"

local map = vim.keymap.set

map("i", "jj", "<ESC>")
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Disable mappings
local nomap = vim.keymap.del

nomap("i", "<C-k>")
nomap("n", "<C-k>")
nomap("n", "<leader>e")

-- oil.nvim
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- winresizer
map("n", "<leader>e", "<CMD>WinResizerStartResize<CR>", { desc = "Start window resize" })

-- Neotest keybindings
--run current file
map("n", "<leader>tr", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run current file" })

map("n", "<leader>td", function()
  require("neotest").run.run { strategy = "dap" }
end, { desc = "Debug nearest test" })

map("n", "<leader>tS", function()
  require("neotest").run.stop()
end, { desc = "Stop nearest test" })

map("n", "<leader>ta", function()
  require("neotest").run.attach()
end, { desc = "Attach to nearest test" })

map("n", "<leader>to", function()
  require("neotest").output.open()
end, { desc = "Open output window" })

map("n", "<leader>tc", function()
  require("neotest").output.close()
end, { desc = "Close output window" })

map("n", "<leader>tw", function()
  require("neotest").output.toggle()
end, { desc = "Toggle output window" })

map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Show test summary" })

-- dap key mappings
map("n", "<leader>dr", function()
  require("dapui").setup()
  require("dap").continue()
end, { desc = "DAP continue" })

map("n", "<leader>db", function()
  require("dapui").setup()
  require("dap").toggle_breakpoint()
end, { desc = "DAP toggle breakpoint" })

-- tmux navigate keys
map({ "n" }, "<c-h>", "<cmd> TmuxNavigateLeft<Cr>", { desc = "Tmux navigate left" })
map({ "n" }, "<c-j>", "<cmd> TmuxNavigateDown<Cr>", { desc = "Tmux navigate Down" })
map({ "n" }, "<c-k>", "<cmd> TmuxNavigateUp<Cr>", { desc = "Tmux navigate Up" })
map({ "n" }, "<c-l>", "<cmd> TmuxNavigateRight<Cr>", { desc = "Tmux navigate Right" })

--The primeagen helpful keymaps
map("n", "<leader>u", vim.cmd.UndotreeToggle, { noremap = true, silent = true })
map("n", "<leader>y", '"+y', { noremap = true, silent = true })
map("v", "<leader>y", '"+y', { noremap = true, silent = true })
map("n", "n", "nzzzv", { desc = "Move to next search item and center it" })
map("x", "<leader>p", '"_dp', { noremap = true, silent = true }, { desc = "Paste without yanking" })
map("n", "J", "mzJ`z", { noremap = true, silent = true }, { desc = "Join lines and keep cursor position" })
map("n", "<leader>sf", "<cmd>normal! ggVG<CR>", { noremap = true, silent = true, desc = "Select whole file" })

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Code Runner
map("n", "<leader>cr", ":RunCode<CR>", { noremap = true, silent = false }, { desc = "Run code" })

-- Trouble.nvim
map(
  "n",
  "<leader>tx",
  "<cmd>Trouble diagnostics toggle<cr>",
  { noremap = true, silent = true },
  { desc = "Diagnostics (Trouble)" }
)

-- Todo comments
map("n", "<leader>tt", "<cmd>TodoTrouble<CR>", { noremap = true, silent = true }, { desc = "Search TODO comments" })

-- vim dadbob ui
map("n", "<leader>du", "<cmd>DBUIToggle<CR>", { noremap = true, silent = true }, { desc = "Toggle DBUI" })

-- package-info.nvim

nomap("n", "<leader>n")

-- noice.nivm
map({ "n" }, "<leader>nc", "<cmd>Noice dismiss<CR>", { silent = true, noremap = true, desc = "Noice dismiss all" })
map(
  { "n" },
  "<leader>nt",
  "<cmd>Noice telescope<CR>",
  { silent = true, noremap = true, desc = "Telescope Noice messages" }
)

-- diffview.nvim
map("n", "<leader>dh", "<cmd>:DiffviewFileHistory %<CR>", { desc = "TagbarToggle" })

-- tailwind tools
map("n", "<leader>tlc", "<cmd>Telescope tailwind classes<CR>", { desc = "Telescope tailwind classes picker" })
map("n", "<leader>tlu", "<cmd>Telescope tailwind utilities<CR>", { desc = "Telescope tailwind utilities picker" })
map("n", "<leader>tls", "<cmd>TailwindSort<CR>", { desc = "Tailwind classes sort" })
map("v", "<leader>tls", "<cmd>TailwindSortSelection<CR>", { desc = "Tailwind classes sort" })
map("n", "<leader>tlf", "<cmd>TailwindConcealToggle<CR>", { desc = "toggle tailwind fold classes" })

-- Neogit
map("n", "<leader>gs", function()
  require("neogit").open()
  require "custom.commit_hook"
end, { desc = "git status" })

map("n", "<leader>gc", function()
  require("neogit").open { "commit" }
  require "custom.commit_hook"
end, { desc = "git commit" })

map("n", "<leader>gP", function()
  require("neogit").open { "push" }
end, { desc = "git push" })

map("n", "<leader>gp", function()
  require("neogit").open { "pull" }
end, { desc = "git pull" })

map("n", "<leader>gB", "<CMD>Telescope git_branches<CR>", { desc = "git branches" })

-- iron repl
vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<space>rt", "<cmd>IronHide<cr>")

-- Leet code
map("n", "<localleader>lm", "<cmd>Leet<CR>", { desc = "open Leet menu/dashboard" })
map("n", "<localleader>lr", "<cmd>Leet run<CR>", { desc = "Leet code run" })
map("n", "<localleader>ls", "<cmd>Leet submit<CR>", { desc = "Leet code submit" })
map("n", "<localleader>le", "<cmd>Leet exit<CR>", { desc = "Leet exit" })
map("n", "<localleader>lc", "<cmd>Leet console<CR>", { desc = "Leet console" })
map("n", "<localleader>lp", "<cmd>Leet last_submit<CR>", { desc = "Leet code last_submit" })
map("n", "<localleader>li", "<cmd>Leet info<CR>", { desc = "Leet code info" })
map("n", "<localleader>lo", "<cmd>Leet open<CR>", { desc = "leet open in browser" })

-- Tstools
-- Sort and remove unused imports
map("n", "<localleader>to", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Organize and remove unused imports" })

-- Sort imports
map("n", "<localleader>tsi", "<cmd>TSToolsSortImports<CR>", { desc = "Sort imports" })

-- Remove unused imports
map("n", "<localleader>tri", "<cmd>TSToolsRemoveUnusedImports<CR>", { desc = "Remove unused imports" })

-- Remove all unused statements
map("n", "<localleader>tru", "<cmd>TSToolsRemoveUnused<CR>", { desc = "Remove all unused statements" })

-- Add missing imports
map("n", "<localleader>tam", "<cmd>TSToolsAddMissingImports<CR>", { desc = "Add missing imports" })

-- Fix all fixable errors
map("n", "<localleader>tfa", "<cmd>TSToolsFixAll<CR>", { desc = "Fix all errors" })

-- Go to source definition
map("n", "<localleader>tsd", "<cmd>TSToolsGoToSourceDefinition<CR>", { desc = "Go to source definition" })

-- Rename the current file and apply changes to connected files
map("n", "<localleader>trf", "<cmd>TSToolsRenameFile<CR>", { desc = "Rename file and update references" })

-- Find files that reference the current file
map("n", "<localleader>tfr", "<cmd>TSToolsFileReferences<CR>", { desc = "Find file references" })

-- for working with ts-tools in js
map("n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })

-- toggle line numbers
map("n", "<leader>nn", "<cmd>set nu!<CR>", { desc = "Toggle line number" })

-- avante.nvim
map("n", "<leader>ac", "<cmd>AvanteClear<CR>", { desc = "Avante clear" })

-- copilot chat
map("n", "<localleader>co", "<cmd>CopilotChatOpen<CR>", { desc = "Open Copilot Chat" })
map("n", "<A-c>", "<cmd>CopilotChatToggle<CR>", { desc = "CopilotChatToggle" })
map("n", "<localleader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Explain the active selection" })
map("n", "<localleader>cr", "<cmd>CopilotChatReview<CR>", { desc = "Review the selected code" })
map("n", "<localleader>cf", "<cmd>CopilotChatFix<CR>", { desc = "Fix the selected code" })
map("n", "<localleader>cz", "<cmd>CopilotChatOptimize<CR>", { desc = "Optimize the selected code" })
map("n", "<localleader>cgd", "<cmd>CopilotChatDocs<CR>", { desc = "Add documentation comment" })
map("n", "<localleader>ct", "<cmd>CopilotChatTests<CR>", { desc = "Add tests to this code" })
map("n", "<localleader>cd", "<cmd>CopilotChatFixDiagnostic<CR>", { desc = "Fix diagnostic issue" })
map("n", "<localleader>cm", "<cmd>CopilotChatCommit<CR>", { desc = "Write commit message" })
map("n", "<localleader>cs", "<cmd>CopilotChatCommitStaged<CR>", { desc = "Write commit message for staged changes" })
map("n", "<localleader>cq", function()
  local input = vim.fn.input "Quick Chat: "
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end, {
  desc = "CopilotChat - Quick chat",
})

-- plugin dev mappings
map("n", "<localleader>rf", "<cmd>source % <CR>", { desc = "run current File" })
-- Convert filepath to module name
-- e.g. /home/user/.config/nvim/lua/mymodule.lua -> mymodule
local function get_current_module_name()
  local filepath = vim.fn.expand "%:p"
  -- Get everything after /lua/ directory
  local module = filepath:match "/lua/(.+)$"
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
    print "Not a valid lua module path"
  end
end, { desc = "Reload current lua file as module" })

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
