require "nvchad.mappings"

local map = vim.keymap.set

local bufnr = vim.api.nvim_get_current_buf()
map("n", "<leader>ca", function()
  vim.cmd.RustLsp "codeAction" -- supports rust-analyzer's grouping
  -- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr, desc = "Code Action" })

map(
  "n",
  "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp { "hover", "actions" }
  end,
  { silent = true, buffer = bufnr }
)

map("n", "gd", function()
  vim.lsp.buf.definition()
end, { silent = true, buffer = bufnr, desc = "Go to Definition" })

map("n", "gr", function()
  vim.lsp.buf.references()
end, { silent = true, buffer = bufnr, desc = "Go to References" })
