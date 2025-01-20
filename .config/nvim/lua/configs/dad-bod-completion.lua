local cmp = require "cmp"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    local existing_sources = cmp.get_config().sources or {}
    table.insert(existing_sources, { name = "vim-dadbod-completion" })
    cmp.setup.buffer {
      sources = existing_sources,
    }
  end,
})
