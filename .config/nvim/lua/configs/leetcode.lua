local leetcode = require("leetcode")
local home_dir = vim.fn.expand("~")
local leet_path
if home_dir:match("^/home/cleo2$") then
  leet_path = "/DevDrive/leetcode/"
else
  leet_path = "/media/DevDrive/leetcode"
end


-- disable copilot for leet code
vim.cmd("Copilot disable")

leetcode.setup({
  lang = "typescript",
  picker = "snacks-picker",
  plugins = {
    non_standalone = true,
    -- image_support = false,
  },
  storage = {
    home = leet_path,
    cache = vim.fn.stdpath("cache") .. "/leetcode",
  },
})
