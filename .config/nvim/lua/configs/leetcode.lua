local leetcode = require "leetcode"

leetcode.setup {
  lang = "typescript",
  plugins = {
    non_standalone = true,
    -- image_support = false,
  },
  storage = {
    home = "/media/DevDrive/leetcode",
    cache = vim.fn.stdpath "cache" .. "/leetcode",
  },
}
