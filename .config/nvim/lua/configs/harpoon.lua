require "nvchad.mappings"

local harpoon = require "harpoon"

-- REQUIRED
harpoon:setup()

-- Disable existing mapping for `<leader>h` default of nvchad
vim.keymap.del("n", "<leader>h")

-- Set new Harpoon mappings
vim.keymap.set("n", "<leader>ha", function()
  harpoon:list():add()
end, { desc = "Add current file to Harpoon list" })

vim.keymap.set("n", "<leader>hm", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle Harpoon quick menu" })

vim.keymap.set("n", "<leader>j", function()
  harpoon:list():select(1)
end, { desc = "Select first file in Harpoon list" })

vim.keymap.set("n", "<leader>k", function()
  harpoon:list():select(2)
end, { desc = "Select second file in Harpoon list" })

vim.keymap.set("n", "<leader>l", function()
  harpoon:list():select(3)
end, { desc = "Select third file in Harpoon list" })

vim.keymap.set("n", "<leader>;", function()
  harpoon:list():select(4)
end, { desc = "Select fourth file in Harpoon list" })

vim.keymap.set("n", "<leader>5", function()
  harpoon:list():select(5)
end, { desc = "Select fifth file in Harpoon list" })

vim.keymap.set("n", "<leader>6", function()
  harpoon:list():select(6)
end, { desc = "Select sixth file in Harpoon list" })
