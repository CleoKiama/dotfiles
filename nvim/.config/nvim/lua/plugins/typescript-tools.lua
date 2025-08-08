return {
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      {
        "davidosomething/format-ts-errors.nvim",
        config = function()
          require("format-ts-errors").setup({
            add_markdown = true,
            start_indent_level = 0,
          })
        end,
      },
    },
    config = function()
      require("configs.js_ts_snippets")
      local lsp = require("configs.lspconfig")
      local navic = require("nvim-navic")
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          lsp.on_attach(client, bufnr)
          navic.attach(client, bufnr)
        end,
        capabilities = lsp.capabilities,
        settings = {
          tsserver_max_memory = "auto", -- or a higher number like "2048"
          -- For better performance in large projects
          separate_diagnostic_server = false,
          -- Compromise settings that work for most projects
          tsserver_file_preferences = {
            importModuleSpecifierPreference = "auto",
            importModuleSpecifierEnding = "auto",
          },
        },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("tsconfig.json", "package.json")(fname)
        end,
        complete_function_calls = true,
        expose_as_code_action = "all",
        jsx_close_tag = {
          enable = true,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      })
    end,
  },
}
