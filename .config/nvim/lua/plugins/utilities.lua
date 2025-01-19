local leet_arg = "leetcode.nvim"
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
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    lazy = leet_arg ~= vim.fn.argv(0, -1),
    -- cmd = "Leet",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require "configs.leetcode"
    end,
  },
  {
    "nvzone/timerly",
    cmd = "TimerlyToggle",
    keys = { { "<leader>mt", "<cmd>TimerlyToggle<CR>", desc = "TimerlyToggle" } },
  },
  {
    "Goose97/timber.nvim",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufReadPre" },
    config = function()
      require("timber").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  { "wakatime/vim-wakatime", event = "VeryLazy" },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("telescope").load_extension "smart_open"
    end,
    dependencies = {
      { "kkharji/sqlite.lua" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope").extensions.smart_open.smart_open {
            cwd_only = true,
            filename_first = true,
          }
        end,
        desc = "[p] find files (smart open)",
      },
    },
  },
}
