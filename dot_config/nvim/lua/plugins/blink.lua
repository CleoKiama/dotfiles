return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      "disrupted/blink-cmp-conventional-commits",
      "moyiz/blink-emoji.nvim",
      {
        "saghen/blink.compat",
        opts = {},
      },
    },
    event = { "InsertEnter", "CmdLineEnter" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      cmdline = {
        keymap = {
          ["<Tab>"] = { "accept" },
        },
        completion = {
          menu = { auto_show = true },
        },
      },
      completion = {
        menu = { auto_show = true },
        documentation = {
          auto_show = true,
        },
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = {
          "lsp",
          "snippets",
          "path",
          "buffer",
          "lazydev",
        },
        per_filetype = {
          sql = { "dadbod" },
          git = { "conventional_commits" },
          NeogitCommitMessage = { "conventional_commits" },
          markdown = { "emoji", "snippets" },
        },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            opts = {}, -- Passed to the source directly, varies by source
            --- NOTE: All of these options may be functions to get dynamic behavior
            --- See the type definitions for more information
            enabled = true,           -- Whether or not to enable the provider
            async = false,            -- Whether we should show the completions before this provider returns, without waiting for it
            timeout_ms = 2000,        -- How long to wait for the provider to return before showing completions and treating it as asynchronous
            transform_items = nil,    -- Function to transform the items before they're returned
            should_show_items = true, -- Whether or not to show the items
            max_items = 20,           -- Maximum number of items to display in the menu
            min_keyword_length = 0,   -- Minimum number of characters in the keyword to trigger the provider
            -- If this provider returns 0 items, it will fallback to these providers.
            -- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
            fallbacks = {},
            score_offset = 0, -- Boost/penalize the score of the items
            override = nil,   -- Override the source's functions
          },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              -- options for blink-cmp-avante
            },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 85,
            enabled = function()
              return vim.bo.filetype == "lua"
            end,
          },
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
            min_keyword_length = 2,
            score_offset = 80,
          },
          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 10,
            min_keyword_length = 1,
            module = "blink.cmp.sources.snippets",
            score_offset = 0,
          },
          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            enabled = function()
              return vim.bo.filetype == "gitcommit"
            end,
            ---@module 'blink-cmp-conventional-commits'
            ---@type blink-cmp-conventional-commits.Options
            opts = {}, -- none so far
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            opts = { insert = true },
            should_show_items = function()
              return vim.tbl_contains(
              -- Enable emoji completion only for git commits and markdown.
              -- By default, enabled for all file-types.
                { "gitcommit", "markdown" },
                vim.o.filetype
              )
            end,
          },
          opencode_context = {
            name = "OpenCode Context",
            module = "custom.opencode.completion_source",
            enabled = function()
              local buf_name = vim.api.nvim_buf_get_name(0)
              return buf_name:match("opencode://") ~= nil
            end,
            score_offset = 1000,
            min_keyword_length = 1,
          },
        },
      },
      keymap = {
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-y>"] = { "select_and_accept" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
      },
    },
  },
}
