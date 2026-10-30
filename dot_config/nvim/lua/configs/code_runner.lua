require("code_runner").setup({
	mode = "vimux",
	startinsert = true,
	filetype = {
		python = "uv run",
		typescript = "bun run",
		gleam = "gleam run",
		go = "go run",
		rust = "cargo run",
	},
})
