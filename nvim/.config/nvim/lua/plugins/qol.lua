local leet_arg = "leetcode.nvim"

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>nl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>nc",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("configs.harpoon")
    end,
  },
  {
    "CRAG666/code_runner.nvim",
    dependencies = { "preservim/vimux" },
    config = function()
      require("configs.code_runner")
    end,
    keys = {
      {
        "<leader>cr",
        function()
          vim.cmd("VimuxClearTerminalScreen")
          vim.cmd("RunCode")
        end,
        desc = "[p] Run code",
      },
      {
        "<leader>ci",
        "<cmd>VimuxInspectRunner<CR>",
        desc = "Inspect the code in the terminal",
      },
    }
  },
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup()
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
        width = 40,         -- Width of the vertical split
      },
    },
    confg = function(_, opts)
      -- dofile(vim.g.base46_cache .. "trouble")
      require("trouble").setup(opts)
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("configs.todoComment")
    end,
  },
  {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    config = function()
      require("configs.navic")
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
    "axelvc/template-string.nvim",
    ft = { "html", "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte", "python" },
    config = function()
      require("template-string").setup({
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
        jsx_brackets = true,            -- must add brackets to JSX attributes
        remove_template_string = false, -- remove backticks when there are no template strings
        restore_quotes = {
          -- quotes used when "remove_template_string" option is enabled
          normal = [[']],
          jsx = [["]],
        },
      })
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    config = function()
      require("highlight-undo").setup({
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
      })
    end,
    keys = { { "u" }, { "<C-r>" } },
  },
  {
    "Vigemus/iron.nvim",
    cmd = "IronRepl",
    config = function()
      require("configs.iron")
    end,
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
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "astro",
      "glimmer",
      "handlebars",
      "html",
      "javascript",
      "jsx",
      "markdown",
      "php",
      "rescript",
      "svelte",
      "tsx",
      "twig",
      "typescript",
      "vue",
      "xml",
    },
    config = function()
      require("configs.nvim-ts-autotag")
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
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
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("configs.leetcode")
    end,
  },
  {
    "Goose97/timber.nvim",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufReadPre" },
    config = function()
      require("timber").setup({
        -- Configuration here, or leave empty to use defaults
      })
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
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
}
