require("code_runner").setup({
  mode = "vimux",
  startinsert = true,
  filetype = {
    python = "python3 -u",
    typescript = "bun run",
    gleam = "gleam run",
    go = "go run",
    rust = "cargo run",
  },
})
