require("nvim-navic").setup {
  icons = {
    File = " ",
    Module = " ",
    Namespace = " ",
    Package = " ",
    Class = " ",
    Method = " ",
    Property = " ",
    Field = " ",
    Constructor = " ",
    Enum = " ",
    Interface = " ",
    Function = " ",
    Variable = " ",
    Constant = " ",
    String = " ",
    Number = " ",
    Boolean = " ",
    Array = " ",
    Object = " ",
    Key = " ",
    Null = " ",
    EnumMember = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
  },
}

local lspconfig = require "lspconfig"

-- JavaScript (tsserver)
lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
  end,
}

-- Elixir (elixirls)
lspconfig.elixirls.setup {
  on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
  end,
  cmd = { "/home/cleo/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
}

-- HTML (html)
lspconfig.html.setup {
  on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
  end,
}

-- CSS (cssls)
lspconfig.cssls.setup {
  on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
  end,
}

-- Lua (sumneko_lua)
lspconfig["lua_ls"].setup {
  on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
  end,
}

--gleam
lspconfig.gleam.setup {
  on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
  end,
}

-- Case the highlights are not defined in Kanagawa
vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = "#000000", fg = "#ffffff" })
