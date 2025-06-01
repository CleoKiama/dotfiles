---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  transparency = false,
}

local function navic_location_with_icon()
  local navic = require("nvim-navic")
  local devicons = require("nvim-web-devicons")
  local location = navic.get_location()

  if location ~= "" then
    local filepath = vim.fn.expand("%:p:~:.")
    local filename = vim.fn.expand("%:t")
    local ext = vim.fn.expand("%:e")

    -- Get the icon for the file type
    local icon = devicons.get_icon(filename, ext, { default = true }) or ""

    -- Replace "/" with ">" except for the last part (filename)
    local path_parts = vim.split(filepath, "/")
    local file_with_icon = icon .. " " .. table.remove(path_parts) -- Add icon before filename
    local formatted_path = table.concat(path_parts, " > ")

    return formatted_path .. " > " .. file_with_icon .. " > " .. location
  else
    return location
  end
end

M.ui = {
  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "tabs", "navic", "Separator" },
    modules = {
      navic = navic_location_with_icon,
      Separator = function()
        return " "
      end,
    },
  },
  statusline = {
    -- more opts
    order = {
      "mode",
      "file",
      "git",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "linters_active",
      "cwd",
      "cursor",
    }, -- check stl/utils.lua file in ui repo
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
    theme = "default",
    separator_style = "default",
  },
}

M.lsp = {
  signature = false,
}

M.nvdash = {
  load_on_startup = (function()
    -- Get the arguments passed to nvim
    local args = vim.v.argv
    -- Check if leetcode.nvim is in the arguments
    for _, arg in ipairs(args) do
      if arg:find("leetcode.nvim") then
        return false -- Don't load nvdash for leetcode
      end
    end

    return true -- Load nvdash for other cases
  end)(),

  header = {
    [[                                                                     ]],
    [[       ████ ██████           █████      ██                     ]],
    [[      ███████████             █████                             ]],
    [[      █████████ ███████████████████ ███   ███████████   ]],
    [[     █████████  ███    █████████████ █████ ██████████████   ]],
    [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
    [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
    [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    [[                           🚀🚀                                      ]],
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
