local iron = require "iron.core"
local view = require "iron.view"

local function get_js_ts_repl_command(default_command)
  local input = vim.fn.input "are you working with mongosh? (y/n): "
  if input == "y" then
    local useLocalHost = vim.fn.input "Do you want to connect to localhost? (y/n): "
    if useLocalHost == "y" then
      return { "mongosh" }
    else
      return { "mongosh", "--nodb" }
    end
  else
    return { default_command }
  end
end

iron.setup {
  config = {
    -- whether a repl should be discarded or not
    scratch_repl = true,
    -- your repl definitions come here
    repl_definition = {
      sh = {
        -- can be a table or a function that
        -- returns a table (see below)
        command = { "zsh" },
      },
      javascript = {
        command = function()
          return get_js_ts_repl_command "node"
        end,
      },
      typescript = {
        command = function()
          return get_js_ts_repl_command "ts-node"
        end,
      },
      python = {
        command = { "python3" }, -- or { "ipython", "--no-autoindent" }
        format = require("iron.fts.common").bracketed_paste_python,
      },
      elixir = {
        command = function()
          local input = vim.fn.input "are you working with phoenix? (y/n): "
          if input == "y" then
            return { "iex", "-S", "mix", "phx.server" }
          else
            return { "iex", "-S", "mix" }
          end
        end,
      },
    },
    -- repl_open_cmd = view.split.vertical("40%"),
    repl_open_cmd = view.split.vertical("40%", {
      winfixwidth = false,
      winfixheight = false,
      -- any window-local configuration can be used here
      number = true,
    }), -- how the repl window will be displayed
    -- see below for more information
  },

  -- iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    visual_send = "<space>sc",
    send_file = "<space>sf",
    send_line = "<space>sl",
    send_paragraph = "<space>sp",
    send_until_cursor = "<space>su",
    send_mark = "<space>sm",
    mark_motion = "<space>mc",
    mark_visual = "<space>mc",
    remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true,
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}
