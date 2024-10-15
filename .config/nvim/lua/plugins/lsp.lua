return {
  {
    "folke/lsp-colors.nvim",
    event = "LspAttach",
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    config = function()
      require("nvim-lightbulb").setup {
        autocmd = { enabled = true },
      }
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "javascript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("typescript-tools").setup {}
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-tree.lua" },
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require "configs.preview"
    end,
    keys = {
      {
        "gpd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        desc = "Goto preview definition",
      },
      {
        "gpt",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        desc = "Goto preview type definition",
      },
      {
        "gpi",
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        desc = "Goto preview implementation",
      },
      {
        "gpD",
        "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
        desc = "Goto preview declaration",
      },
      { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "close preview-win" },
      {
        "gpr",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        desc = "Goto preview references",
      },
    },
  },
}
