local highlight = {
  "ScopeHighlight",
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "ScopeHighlight", { fg = "#C090FF" }) -- Dark purple color
end)

require("ibl").setup {
  scope = {
    char = "│",
    highlight = highlight,
  },
  indent = {
    char = "│",
  },
}
