require "nvchad.mappings"

local map = vim.keymap.set

-- I have some issues with go to definition in typescript-tools so I am rebinding it to the call to the lsp

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })

map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })

map("n", "GD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })

map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })
