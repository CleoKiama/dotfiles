require "nvchad.mappings"

local map = vim.keymap.set

-- I have some issues with go to definition in typescript-tools so I am rebinding it to the call to the lsp

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })

map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })

map("n", "GD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })

map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })

-- load vs code snippets for Es6 plus redux
require("luasnip.loaders.from_vscode").lazy_load {
  paths = {
    "~/.vscode/extensions/dsznajder.es7-react-js-snippets-4.4.3/lib/snippets/generated.json",
    "~/.vscode/extensions/burkeholland.simple-react-snippets-1.2.8/snippets/snippets.json",
    "~/.vscode/extensions/burkeholland.simple-react-snippets-1.2.8/snippets/snippets-ts.json",
  },
}

local cmp = require "cmp"
local sources = cmp.get_config().sources

-- Add nil check before iterating
if sources then
  -- Find and modify luasnip priority
  for _, source in ipairs(sources) do
    if source.name == "luasnip" then
      source.priority = 1000
      break
    end
  end

  -- Apply the modified sources
  cmp.setup {
    sources = sources,
  }
end
