return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
    },
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre /media/Library/obsidian-vaults/**.md",
      "BufNewFile /media/Library/obsidian-vaults/**.md",
      "BufWritePost /media/Library/obsidian-vaults/**.md",
    },
    ft = { "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    config = function()
      require("render-markdown").setup {}
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre /media/Library/obsidian-vaults/**.md",
      "BufNewFile /media/Library/obsidian-vaults/**.md",
      "BufWritePost /media/Library/obsidian-vaults/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      -- see below for full list of optional dependencies 👇
    },
    config = function()
      vim.cmd "set conceallevel=2"
      require "configs.obsidian"
    end,
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    cmd = "Leet",
    ft = { "png", "jpg", "jpeg", "gif" },
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre /media/Library/obsidian-vaults/**.md",
      "BufNewFile /media/Library/obsidian-vaults/**.md",
      "BufWritePost /media/Library/obsidian-vaults/**.md",
    },
    config = function()
      require "configs.image_nvim"
    end,
  },
}
