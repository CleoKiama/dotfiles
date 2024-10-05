return {
  {
    "folke/noice.nvim",
    event = "InsertEnter",
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
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>S",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.grug_far {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  {
    {
      "stevearc/aerial.nvim",
      cmd = "Telescope aerial",
      config = function()
        require("telescope").load_extension "aerial"
        require("aerial").setup {
          backends = { "lsp", "treesitter", "markdown", "man" },
        }
      end,
      keys = {
        { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
      },
    },
  },
  {
    "simeji/winresizer",
    keys = {
      { "<leader>e", "<cmd>WinResizerStartResize<cr>", desc = "winresizer" },
    },
  },
  {
    "folke/flash.nvim",
    opts = {},
  -- stylua: ignore
  keys = {
    { "<localleader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<localleader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "<localleader>r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "<localleader>R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
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
        }, -- filetypes where the plugin is active
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
    -- event = "VeryLazy",
    disabled = true,
    dependencies = { "nvim-lua/plenary.nvim", "3rd/image.nvim" },
    opts = {
      pathToVault = "/media/Library/obsidian-vaults/10xGoals/Journal/Dailies",
    },
  },
}
