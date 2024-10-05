local M = {}

M.keys = {
  { "<leader>re", ":Refactor extract ", mode = "x", desc = "Extract function" },
  { "<leader>rF", ":Refactor extract_to_file ", mode = "x", desc = "Extract function to file" },
  { "<leader>rv", ":Refactor extract_var ", mode = "x", desc = "Extract variable" },
  { "<leader>ri", ":Refactor inline_var", mode = { "x", "n" }, desc = "Inline variable" },
  { "<leader>rI", ":Refactor inline_func", mode = "n", desc = "Inline function" },
  { "<leader>rb", ":Refactor extract_block", mode = "n", desc = "Extract block" },
  { "<leader>rf", ":Refactor extract_block_to_file", mode = "n", desc = "Extract block to file" },
}

M.opts = {
  prompt_func_return_type = {
    go = false,
    java = false,
    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },
  prompt_func_param_type = {
    go = false,
    java = false,
    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },
  printf_statements = {},
  print_var_statements = {},
  show_success_message = true, -- shows a message with information about the refactor on success
  -- i.e. [Refactor] Inlined 3 variable occurrences
}

return M
