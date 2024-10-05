require("code_runner").setup {
  mode = "float",
  startinsert = true,
  float = {
    border = "rounded",
    width = 0.5,
    x = 0.5,
    y = 0.5,
  },
  filetype = {
    python = "python3 -u",
    typescript = "bun run",
    gleam = "gleam run",
  },
}
