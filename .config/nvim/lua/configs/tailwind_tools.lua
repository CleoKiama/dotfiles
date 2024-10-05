local cmp = require "cmp"
local lspkind = require "lspkind"
local tailwind_tools = require "tailwind-tools.cmp"

require("tailwind-tools").setup {
  document_color = {
    enabled = true, -- can be toggled by commands
    kind = "inline", -- "inline" | "foreground" | "background"
    inline_symbol = "󰝤 ", -- only used in inline mode
    debounce = 200, -- in milliseconds, only applied in insert mode
  },
  conceal = {
    enabled = false, -- can be toggled by commands
    min_length = nil, -- only conceal classes exceeding the provided length
    symbol = "󱏿", -- only a single character is allowed
    highlight = { -- extmark highlight options, see :h 'highlight'
      fg = "#38BDF8",
    },
  },
  telescope = {
    utilities = {
      -- the function used when selecting an utility class in telescope
      callback = function(name, class) end,
    },
  },
  -- see the extension section to learn more
  extension = {
    queries = {}, -- a list of filetypes having custom `class` queries
    patterns = { -- a map of filetypes to Lua pattern lists
      -- exmaple:
      -- rust = { "class=[\"']([^\"']+)[\"']" },
      -- javascript = { "clsx%(([^)]+)%)" },
    },
  },
}

-- first set up lspking
cmp.setup {
  formatting = {
    format = lspkind.cmp_format {
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end,
    },
  },
}

-- then setup tailwind_tools
cmp.setup {
  formatting = {
    format = lspkind.cmp_format {
      before = tailwind_tools.lspkind_format,
    },
  },
  -- Add other nvim-cmp options here
}
