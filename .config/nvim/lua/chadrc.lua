-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "kanagawa",
  transparency = false,
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "navic", "Separator", "btns" },
    modules = {
      navic = function()
        return require("nvim-navic").get_location()
      end,
      Separator = function()
        return " "
      end,
    },
  },
  statusline = {
    -- more opts
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "linters_active", "cwd", "cursor" }, -- check stl/utils.lua file in ui repo
    modules = {
      -- The default cursor module is override
      linters_active = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "󰦕"
        end
        return "󱉶 " .. table.concat(linters, ", ")
      end,
    },

    -- Separator style and theme
    theme = "default", -- default, vscode, vscode_colored or minimal
    -- default, round, block, and arrow are supported only by the default statusline theme.
    -- the round and block separators are also supported by the minimal theme.
    separator_style = "default", -- default, round, block or arrow
  },
}
M.nvdash = {
  load_on_startup = true,
  header = {
    [[                                                                       ]],
    [[  ██████   █████                   █████   █████  ███                  ]],
    [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
    [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
    [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
    [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
    [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
    [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
    [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
    [[                                                                       ]],
    [[                          🚀🚀                                         ]],
    [[                                                                       ]],
  },
  buttons = {
    { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = "Spc t h", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },

    { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashLazy",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
  },
}

return M
