return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "Avante", "copilot-chat" },
    opts = {
      checkbox = {
        -- Turn on / off checkbox state rendering
        enabled = true,
        -- Determines how icons fill the available space:
        --  inline:  underlying text is concealed resulting in a left aligned icon
        --  overlay: result is left padded with spaces to hide any additional text
        position = "inline",
        unchecked = {
          -- Replaces '[ ]' of 'task_list_marker_unchecked'
          icon = "󰄱",
          -- Highlight for the unchecked icon
          highlight = "ObsidianTodo",
          -- Highlight for item associated with unchecked checkbox
          scope_highlight = nil,
        },
        checked = {
          -- Replaces '[x]' of 'task_list_marker_checked'
          icon = "",
          -- Highlight for the checked icon
          highlight = "ObsidianDone",
          -- Highlight for item associated with checked checkbox
          scope_highlight = nil,
        },
        -- Define custom checkbox states, more involved as they are not part of the markdown grammar
        -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
        -- Can specify as many additional states as you like following the 'todo' pattern below
        --   The key in this case 'todo' is for healthcheck and to allow users to change its values
        --   'raw':             Matched against the raw text of a 'shortcut_link'
        --   'rendered':        Replaces the 'raw' value when rendering
        --   'highlight':       Highlight for the 'rendered' icon
        --   'scope_highlight': Highlight for item associated with custom checkbox
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
          right_arrow = { raw = "[>]", rendered = "", highlight = "ObsidianRightArrow", scope_highlight = nil },
          tilde = { raw = "[~]", rendered = "󰰱", highlight = "ObsidianTilde", scope_highlight = nil },
          important = { raw = "[!]", rendered = "", highlight = "ObsidianImportant", scope_highlight = nil },
        },
      },
    },
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
