-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "marksman",
  "lua_ls",
  "sqlls",
  "gleam",
  "vuels",
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
-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

require "nvchad.mappings"

local map = vim.keymap.set

-- I have some issues with go to definition in elixirls so I am rebinding it to the call to the lsp
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
