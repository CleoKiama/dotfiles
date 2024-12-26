require "nvchad.mappings"

local map = vim.keymap.set

-- I have some issues with go to definition in typescript-tools so I am rebinding it to the call to the lsp

map(
  "n",
  "gd",
  "<cmd>lua vim.lsp.buf.definition()<CR>",
  { noremap = true, silent = true },
  { desc = "Go to definition" }
)

map(
  "n",
  "gr",
  "<cmd>lua vim.lsp.buf.references()<CR>",
  { noremap = true, silent = true },
  { desc = "Go to references" }
)

map(
  "n",
  "<leader>ca",
  "<cmd>lua vim.lsp.buf.code_action()<CR>",
  { noremap = true, silent = true },
  { desc = "Code Action" }
)
