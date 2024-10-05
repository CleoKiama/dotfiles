local cmp = require "cmp"

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "path" }, -- Include file path completions
    { name = "cmdline", option = { ignore_cmds = {} } }, -- Include all commands
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "buffer" }, -- For search completions
  },
})

cmp.setup.cmdline("?", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "buffer" }, -- For search completions
  },
})
