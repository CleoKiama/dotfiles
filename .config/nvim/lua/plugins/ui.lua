return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require "configs.noice"
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter", -- Load when entering command-line mode
    config = function()
      require "configs.cmp_cmdline"
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    cmd = "Oil",
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      win = {
        position = "right", -- Opens Trouble in a vertical split on the right
        width = 40, -- Width of the vertical split
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    config = function()
      require "configs.navic"
    end,
  },
  {
    "simeji/winresizer",
    cmd = "WinResizerStartResize",
  },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", "<Plug>(leap)", desc = "Leap" },
    },
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "axelvc/template-string.nvim",
    ft = { "html", "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte", "python" },
    config = function()
      require("template-string").setup {
        filetypes = {
          "html",
          "typescript",
          "javascript",
          "typescriptreact",
          "javascriptreact",
          "vue",
          "svelte",
          "python",
        },
        jsx_brackets = true, -- must add brackets to JSX attributes
        remove_template_string = false, -- remove backticks when there are no template strings
        restore_quotes = {
          -- quotes used when "remove_template_string" option is enabled
          normal = [[']],
          jsx = [["]],
        },
      }
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    ft = { "html", "javascriptreact", "typescriptreact", "heex" },
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "onsails/lspkind.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require "configs.tailwind_tools"
    end,
    opts = {}, -- your configuration
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    init = function()
      require "configs.bqf_init"
    end,
  },
  {
    "CleoKiama/ObsidianTracker.nvim",
    dev = true,
    name = "CleoKiama/ObsidianTracker.nvim",
    dir = "/home/cleo/plugins/ObsidianTracker.nvim",
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre /media/Library/obsidian-vaults/**.md",
      "BufNewFile /media/Library/obsidian-vaults/**.md",
      "BufWritePost /media/Library/obsidian-vaults/**.md",
    },

    dependencies = { "nvim-lua/plenary.nvim", "3rd/image.nvim" },
    opts = {
      pathToVault = "/media/Library/obsidian-vaults/10xGoals/Journal/Dailies",
    },
  },
  {
    "tzachar/highlight-undo.nvim",
    config = function()
      require("highlight-undo").setup {
        keymaps = {
          paste = {
            desc = "paste",
            hlgroup = "HighlightUndo",
            mode = "n",
            lhs = "p",
            rhs = "p",
            opts = {},
          },
        },
      }
    end,
    keys = { { "u" }, { "<C-r>" } },
  },
}
