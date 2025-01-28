-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "bashls",
  "marksman",
  "prismals",
  "sqlls",
  "gleam",
  "jsonls",
}

local nvlsp = require "nvchad.configs.lspconfig"

--setup navic
local navic = require "nvim-navic"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      navic.attach(client, bufnr)
      nvlsp.on_attach(client, bufnr)
    end,
    -- on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- lspconfig.elixirls.setup {
--   -- Unix
--   cmd = { "/home/cleo/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
-- }
