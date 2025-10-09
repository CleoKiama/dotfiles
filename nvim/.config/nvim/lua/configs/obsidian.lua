require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = vim.g.vault_path,
		},
	},
	daily_notes = {
		folder = "Journal/Dailies",
		template = "journal.md",
	},
	templates = {
		subdir = "Templates",
		date_format = "%Y-%m-%d-%a",
		time_format = "%H:%M",
		tags = "",
	},
	new_notes_location = "current_dir",
	note_id_func = function(title)
		-- Read the note's file.
		local file = io.open(vim.fn.expand("%:p"), "r")
		if file then
			local content = file:read("*all")
			file:close()

			-- Check if the note already has an ID.
			local id = content:match("id: (%S+)")
			if id then
				-- If the note already has an ID, return it.
				return id
			end
		end

		-- If the note does not have an ID, generate a new one.
		local suffix = ""
		if title ~= nil then
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		end
		return os.date("%Y-%m-%d") .. "-" .. suffix
	end,
	disable_frontmatter = false,

	note_frontmatter_func = function(note)
		-- Start with existing metadata or an empty table
		local out = note.metadata or {}

		-- Always update the 'updated_at' field
		out.updated_at = os.date("%Y-%m-%d %H:%M:%S")

		-- Add other fields only if they don't already exist
		if not out.id then
			out.id = note.id
		end
		if not out.aliases then
			out.aliases = note.aliases
		end
		if not out.tags then
			out.tags = note.tags
		end
		if not out.date then
			out.date = os.date("%Y-%m-%d")
		end

		-- Add the title of the note as an alias if it's not already there
		if note.title and not vim.tbl_contains(out.aliases or {}, note.title) then
			out.aliases = out.aliases or {}
			table.insert(out.aliases, note.title)
		end

		return out
	end,
	follow_url_func = function(url)
		-- Open the URL in the default web browser.
		vim.fn.jobstart({ "xdg-open", url }) -- linux
	end,
	picker = {
		-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
		name = "snacks.pick",
	},
	completion = {
		nvim_cmp = false,
		blink = true,
	},
	-- Optional, configure additional syntax highlighting / extmarks.
	-- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
	-- Specify how to handle attachments.
	attachments = {
		-- The default folder to place images in via `:ObsidianPasteImg`.
		-- If this is a relative path it will be interpreted as relative to the vault root.
		-- You can always override this per image by passing a full path to the command instead of just a filename.
		img_folder = "assets/imgs", -- This is the default
		img_name_func = function()
			return ""
		end,
		img_text_func = function(path)
			local vault_path = vim.g.vault_path
			local abs_path = tostring(path)
			local rel_path = abs_path:gsub("^" .. vim.pesc(vault_path .. "/"), "")

			return string.format("![%s](%s)", path.name, rel_path)
		end,
	},
	ui = { enable = false },
})

local map = vim.keymap.set

map("n", "<leader>ont", "<Cmd>Obsidian new_from_template<CR>")
map("n", "<leader>of", "<Cmd>Obsidian follow_link<CR>")
map("n", "<leader>ot", "<Cmd>Obsidian today<CR>")
map("n", "<leader>oy", "<Cmd>Obsidian yesterday<CR>")
map("n", "<leader>o/", "<Cmd>Obsidian search<CR>")
map("n", "<leader>ost", ":Obsidian tags ")
map("n", "<leader>od", "<Cmd>Obsidian dailies<CR>")
map("v", "<leader>oe", ":Obsidian extract_note")
map("n", "<leader>opt", "<Cmd>Obsidian template<CR>")
map("n", "<leader>or", ":Obsidian rename ")
map("n", "<leader>oi", ":Obsidian paste_img<CR> ")

function run_rclone_sync()
	vim.notify("Starting Obsidian sync...", vim.log.levels.INFO)
	local term = require("nvchad.term")
	term.toggle({
		pos = "vsp",
		cmd = "rclone sync -vv " .. vim.g.vault_root_path .. "/ gdrive-obsidian-vault:/Obsidian_vault",
		id = "rclone_sync",
		clear_cmd = false,
	})
end

-- Obsidian sync to GDrive
map("n", "<Leader>osg", ":lua run_rclone_sync()<CR>", { desc = "Sync Obsidian to GDrive" })

require("configs.task_manager")
