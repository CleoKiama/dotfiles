require "nvchad.mappings"

local harpoon = require "harpoon"

-- REQUIRED
harpoon:setup()

-- Disable existing mapping for `<leader>h` default of nvchad
vim.keymap.del("n", "<leader>h")

local map = vim.keymap.set

-- Set new Harpoon mappings
-- Set new Harpoon mappings
map("n", "<leader>ha", function()
  harpoon:list():add()
end, { desc = "[p] Add current file to Harpoon list" })
map("n", "<leader>hm", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "[p] Toggle Harpoon quick menu" })
map("n", "<leader>j", function()
  harpoon:list():select(1)
end, { desc = "[p] Select first file in Harpoon list" })
map("n", "<leader>k", function()
  harpoon:list():select(2)
end, { desc = "[p] Select second file in Harpoon list" })
map("n", "<leader>l", function()
  harpoon:list():select(3)
end, { desc = "[p] Select third file in Harpoon list" })
map("n", "<leader>;", function()
  harpoon:list():select(4)
end, { desc = "[p] Select fourth file in Harpoon list" })
map("n", "<leader>5", function()
  harpoon:list():select(5)
end, { desc = "[p] Select fifth file in Harpoon list" })
map("n", "<leader>6", function()
  harpoon:list():select(6)
end, { desc = "[p] Select sixth file in Harpoon list" })
