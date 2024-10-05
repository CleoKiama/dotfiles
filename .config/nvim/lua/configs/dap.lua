local dapui_loaded, dapui = pcall(require, "dapui")
local dap_loaded, dap = pcall(require, "dap")
local vt_loaded, dap_vt = pcall(require, "nvim-dap-virtual-text")
local utils_loaded, _dap_utils = pcall(require, "dap.utils")

if not dapui_loaded or not dap_loaded or not vt_loaded or not utils_loaded then
  vim.notify "DAP dependencies are missing. Please install them."
  return
end

-- DAP Virtual Text Setup
dap_vt.setup {
  enabled = true, -- Enable plugin (default)
  enabled_commands = true, -- Create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  highlight_changed_variables = true, -- Highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_new_as_changed = false, -- Highlight new variables in the same way as changed variables (if highlight_changed_variables)
  show_stop_reason = true, -- Show stop reason when stopped for exceptions
  commented = false, -- Prefix virtual text with comment string
  only_first_definition = true, -- Only show virtual text at first definition (if there are multiple)
  all_references = false, -- Show virtual text on all references of the variable (not only definitions)
  filter_references_pattern = "<module", -- Filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
  -- Experimental Features:
  virt_text_pos = "eol", -- Position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- Show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false, -- Show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil, -- Position the virtual text at a fixed window column (starting from the first text column)
}

-- DAP UI Setup
dapui.setup {
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has "nvim-0.7", -- Requires Neovim >= 0.7
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "rounded", -- Border style: "single", "double", "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
}

-- DAP Setup
dap.set_log_level "TRACE"

-- Automatically open UI
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
-- Enable virtual text
vim.g.dap_virtual_text = true

-- Icons
vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = 8123,
  executable = {
    command = "js-debug-adapter",
  },
}
local supported_filetypes = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}

for _, language in ipairs(supported_filetypes) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "nodejs",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      name = "Debug with Firefox",
      type = "firefox",
      request = "launch",
      reAttach = true,
      url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
            if url == nil or url == "" then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end,
      webRoot = "${workspaceFolder}",
      firefoxExecutable = "/usr/bin/flatpak run org.mozilla.firefox",
    },
  }
end

dap.adapters.mix_task = {
  name = "mix_task",
  type = "executable",
  command = "/home/cleo/.local/share/nvim/mason/packages/elixir-ls/debug_adapter.sh", -- debug_adapter.bat for windows
  args = {},
}

dap.configurations.elixir = {
  {
    type = "mix_task",
    name = "mix test",
    task = "test",
    taskArgs = { "--trace" },
    request = "launch",
    startApps = true, -- for Phoenix projects
    projectDir = "${workspaceFolder}",
    requireFiles = {
      "test/**/test_helper.exs",
      "test/**/*_test.exs",
    },
  },
}
