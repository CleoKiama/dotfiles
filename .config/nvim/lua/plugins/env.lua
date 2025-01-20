local cmp = require "cmp"
local existing_sources = cmp.get_config().sources or {}
table.insert(existing_sources, { name = "ecolog" })
cmp.setup { sources = existing_sources }

return {
  {
    "philosofonusus/ecolog.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp", -- Optional: for autocompletion support (recommended)
    },
    -- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
    keys = {
      { "<localleader>ge", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
      { "<localleader>ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
      { "<localleader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
    },
    -- Lazy loading is done internally
    event = "VeryLazy",
    opts = {
      integrations = {
        -- WARNING: for both cmp integrations see readme section below
        nvim_cmp = true, -- If you dont plan to use nvim_cmp set to false, enabled by default
        -- If you are planning to use blink cmp uncomment this line
        -- blink_cmp = true,
      },
      -- true by default, enables built-in types (database_url, url, etc.)
      types = true,
      path = vim.fn.getcwd(), -- Path to search for .env files
      preferred_environment = "development", -- Optional: prioritize specific env files
      -- Controls how environment variables are extracted from code and how cmp works
      provider_patterns = true, -- true by default, when false will not check provider patterns
    },
  },
}
