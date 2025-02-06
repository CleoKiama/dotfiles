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
    "karb94/neoscroll.nvim",
    event = { "BufRead", "BufNewFile", "BufWritePost" },
    config = function()
      require("neoscroll").setup {}
    end,
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
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
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
    "RRethy/vim-illuminate",
    event = { "BufRead", "BufNewFile", "BufWritePost" },
    config = function()
      vim.cmd [[
      hi IlluminatedWordText guibg=#264f78 gui=none
      hi IlluminatedWordRead guibg=#264f78 gui=none
      hi IlluminatedWordWrite guibg=#264f78 gui=none
    ]]
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
  {
    "folke/snacks.nvim",
    event = { "BufWritePost" },
    ---@type snacks.Config
    opts = {
      picker = {
        -- your picker configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      notifier = {
        -- your notifier configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        zindex = 600,
      },
    },
    keys = {
      {
        "<leader>fs",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "[p] snacks  LSP Symbols",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.files()
        end,
        desc = "[p] Snacks Find Git Files",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<M-b>",
        function()
          Snacks.picker.git_branches {
            layout = "select",
          }
        end,
        desc = "[p] git branch",
      },
      {
        -- -- You can confirm in your teminal lamw26wmal with:
        -- -- rg "^\s*-\s\[ \]" test-markdown.md
        "<leader>ti",
        function()
          Snacks.picker.grep {
            prompt = " ",
            -- pass your desired search as a static pattern
            search = "^\\s*- \\[ \\]",
            -- we enable regex so the pattern is interpreted as a regex
            regex = true,
            -- no “live grep” needed here since we have a fixed pattern
            live = false,
            -- restrict search to the current working directory
            dirs = { vim.fn.getcwd() },
            -- include files ignored by .gitignore
            args = { "--no-ignore" },
            -- Start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "grep",
            format = "file",
            show_empty = true,
            supports_live = false,
            layout = "ivy",
          }
        end,
        desc = "[P]Search for incomplete tasks",
      },
      -- -- Iterate throuth completed tasks in Snacks_picker lamw26wmal
      {
        "<leader>tc",
        function()
          Snacks.picker.grep {
            prompt = " ",
            -- pass your desired search as a static pattern
            search = "^\\s*- \\[x\\] `done:",
            -- we enable regex so the pattern is interpreted as a regex
            regex = true,
            -- no “live grep” needed here since we have a fixed pattern
            live = false,
            -- restrict search to the current working directory
            dirs = { vim.fn.getcwd() },
            -- include files ignored by .gitignore
            args = { "--no-ignore" },
            -- Start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "grep",
            format = "file",
            show_empty = true,
            supports_live = false,
            layout = "ivy",
          }
        end,
        desc = "[P]Search for incomplete tasks",
      },
    },
  },
}
