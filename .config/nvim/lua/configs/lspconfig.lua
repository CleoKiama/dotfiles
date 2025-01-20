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

-- lspconfig.elixirls.setup {
--   -- Unix
--   cmd = { "/home/cleo/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
-- }
