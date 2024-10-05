return {
  {
    "Vigemus/iron.nvim",
    cmd = "IronRepl",
    config = function()
      require "configs.iron"
    end,
  },
  {
    "Wansmer/treesj",
    cmd = { "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>cj", "<cmd>TSJToggle<CR>", desc = "Toggle code join/split" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require("treesj").setup {--[[ your config ]]
      }
    end,
  },
  { "wakatime/vim-wakatime", event = "VeryLazy" },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "configs.todoComment"
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufRead", "BufNewFile", "BufWritePost" },
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "configs.harpoon"
    end,
  },
  {
    "CRAG666/code_runner.nvim",
    cmd = "RunCode", -- The plugin will be loaded when the RunCode command is called
    config = function()
      require "configs.code_runner"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = true, -- Set to true to enable lazy loading
    event = { "BufReadPre", "BufNewFile" }, -- Specify the events for lazy loading
    config = function()
      require "configs.nvim-ts-autotag"
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("telescope").load_extension "refactoring"
    end,
    keys = require("configs.refactoring_keymaps").keys,
    opts = require("configs.refactoring_keymaps").opts,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
}