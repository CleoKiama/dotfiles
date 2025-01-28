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
