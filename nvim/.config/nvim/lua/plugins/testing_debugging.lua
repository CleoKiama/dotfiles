return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufRead", "BufNewFile", "BufWritePost" },
    config = function()
      require("configs.nvim_lint")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("configs.dap")
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      require("configs.neotest")
    end,
  },
}
