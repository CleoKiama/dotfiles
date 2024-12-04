-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "bashls",
  "marksman",
  "lua_ls",
  "gopls",
  "sqlls",
  "gleam",
  "golangci_lint_ls",
  "jsonls",
}

local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.elixirls.setup {
  -- Unix
  cmd = { "/home/cleo/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
}

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
