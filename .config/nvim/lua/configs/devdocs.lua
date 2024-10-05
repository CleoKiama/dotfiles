local opt = {
  dir_path = vim.fn.stdpath "data" .. "/devdocs", -- installation directory
  telescope = {}, -- passed to the telescope picker
  filetypes = {
    -- extends the filetype to docs mappings used by the `DevdocsOpenCurrent` command, the version doesn't have to be specified
    scss = "sass",
    javascript = { "node", "javascript" },
    elixir = { "elixir", "phoenix", "tailwindcss", "erlang" }, -- added elixir, phoenix, and erlang
    typescript = { "node", "javascript" },
    tsx = { "javascript", "tailwindcss" },
    jsx = { "javascript", "tailwindcss" },
    css = "css",
    html = "html",
  },
  float_win = { -- passed to nvim_open_win(), see :h api-floatwin
    relative = "editor",
    height = 70,
    width = 100,
    border = "rounded",
  },
  wrap = true, -- text wrap, only applies to floating window
  previewer_cmd = "glow", -- for example: "glow"
  cmd_args = { "-s", "dark", "-w", "80" }, -- example using glow: { "-s", "dark", "-w", "80" }
  cmd_ignore = {}, -- ignore cmd rendering for the listed docs
  picker_cmd = true, -- use cmd previewer in picker preview
  picker_cmd_args = { "-s", "dark", "-w", "50" }, -- example using glow: { "-s", "dark", "-w", "50" }
  mappings = { -- keymaps for the doc buffer
    open_in_browser = "<Leader>dob",
  },
  ensure_installed = {}, -- get automatically installed
  -- after_open = function(bufnr) end, -- callback that runs after the Devdocs window is opened. Devdocs buffer ID will be passed in
}

require "nvchad.mappings"
local map = vim.keymap.set

-- Shorter DevDocs key mappings
map("n", "<Leader>df", "<CMD>DevdocsOpenFloat<CR>", { desc = "Open documentation in a floating window" })
map(
  "n",
  "<Leader>dco",
  "<CMD>DevdocsOpenCurrent<CR>",
  { desc = "Open documentation for current filetype in a normal buffer" }
)
map(
  "n",
  "<Leader>dcf",
  "<CMD>DevdocsOpenCurrentFloat<CR>",
  { desc = "Open documentation for current filetype in a floating window" }
)
map("n", "<Leader>dt", "<CMD>DevdocsToggle<CR>", { desc = "Toggle floating window" })
map("n", "<leader>di", "<CMD>DevdocsInstall<CR>", { desc = "Install documentation" })
map("n", "<leader>dU", "<CMD>DevdocsUninstall<CR>", { desc = "Uninstall documentation" })
map("n", "<leader>do", "<CMD>DevdocsOpen<CR>", { desc = "Open documentation in a normal buffer" })
map("n", "<leader>du", "<CMD>DevdocsUpdate<CR>", { desc = "Update documentation" })

return opt
