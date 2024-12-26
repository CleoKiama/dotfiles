local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtTextend
end

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
    "CleoKiama/vizpendulum.nvim",
    dev = true,
    event = "VeryLazy",
    name = "CleoKiama/vizpendulum-nvim",
    dir = "/home/cleo/plugins/vizpendulum.nvim/",
    config = function()
      require("vizpendulum").setup()
    end,
    dependencies = { "nvim-lua/plenary.nvim", "3rd/image.nvim" },
  },
}
