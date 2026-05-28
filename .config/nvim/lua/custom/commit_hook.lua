local async = require("plenary.async")
local vim = vim
local daily_journal_path = "/media/Library/obsidian-vaults/10xGoals/Journal/Dailies/"

local function update_journal()
	async.void(function()
		local current_date = os.date("%Y-%m-%d")
		local file_path = daily_journal_path .. current_date .. ".md"

		-- Check if file exists first
		local exists, _ = vim.loop.fs_stat(file_path)
		if not exists then
			vim.notify("Journal file does not exist: " .. file_path, vim.log.levels.ERROR)
			return
		end

		local fd, err = vim.loop.fs_open(file_path, "r", 438)
		if not fd then
			vim.notify("Failed to open file: " .. (err or "unknown error"), vim.log.levels.ERROR)
			return
		end

		local stat = vim.loop.fs_fstat(fd)
		if not stat then
			vim.loop.fs_close(fd)
			vim.notify("Failed to get file stats", vim.log.levels.ERROR)
			return
		end

		local content = vim.loop.fs_read(fd, stat.size, 0)
		if not content then
			vim.loop.fs_close(fd)
			vim.notify("Failed to read file content", vim.log.levels.ERROR)
			return
		end
		vim.loop.fs_close(fd)

		-- Find and update coding_progress
		local found = false
		local new_content = content:gsub("(coding_progress:)%s*(%d+)", function(prefix, number)
			found = true
			return prefix .. " " .. (tonumber(number) + 1)
		end)

		if not found then
			vim.notify("Could not find 'coding_progress:' in the file", vim.log.levels.WARN)
			return
		end

		-- Write updated content back to file
		fd, err = vim.loop.fs_open(file_path, "w", 438)
		if not fd then
			vim.notify("Failed to open file for writing: " .. (err or "unknown error"), vim.log.levels.ERROR)
			return
		end

		local ok = vim.loop.fs_write(fd, new_content)
		if not ok then
			vim.loop.fs_close(fd)
			vim.notify("Failed to write to file", vim.log.levels.ERROR)
			return
		end
		vim.loop.fs_close(fd)

		vim.notify("Updated coding progress in today's journal", vim.log.levels.INFO)
	end)()
end

vim.api.nvim_create_autocmd("User", {
	pattern = "NeogitCommitComplete",
	callback = function()
		update_journal()
	end,
})
