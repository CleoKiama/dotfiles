require("obsidian").setup {
  workspaces = {
    {
      name = "personal",
      path = "/media/Library/obsidian-vaults/10xGoals",
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
    local file = io.open(vim.fn.expand "%:p", "r")
    if file then
      local content = file:read "*all"
      file:close()

      -- Check if the note already has an ID.
      local id = content:match "id: (%S+)"
      if id then
        -- If the note already has an ID, return it.
        return id
      end
    end

    -- If the note does not have an ID, generate a new one.
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      for _ = 1, 4 do
      end
    end
    return os.date "%Y-%m-%d" .. "-" .. suffix
  end,
  disable_frontmatter = false,

  note_frontmatter_func = function(note)
    -- Start with existing metadata or an empty table
    local out = note.metadata or {}

    -- Always update the 'updated_at' field
    out.updated_at = os.date "%Y-%m-%d %H:%M:%S"

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
      out.date = os.date "%Y-%m-%d"
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
    vim.fn.jobstart { "xdg-open", url } -- linux
  end,

  mappings = {
    -- "Obsidian follow"
    ["<leader>of"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
      { desc = "obsidian follow link" },
    },
    -- Toggle check-boxes "obsidian done"
    ["<leader>od"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
      { desc = "obsidian toggle checkbox" },
    },
    ["<leader>oc"] = {
      action = function()
        vim.cmd " ObsidianToggleCheckbox"
      end,
      opts = { buffer = true },
      { desc = "obsidian cycle checkbox" },
    },
    ["<leader>or"] = {
      action = function()
        vim.cmd "ObsidianTomorrow"
      end,
      opts = { buffer = true },
      { desc = "obsidian jump to tomorrow" },
    },
    ["<leader>on"] = {
      action = function()
        vim.cmd "ObsidianNew"
      end,
      opts = { buffer = true },
      { desc = "obsidian new note" },
    },

    ["<leader>oy"] = {
      action = function()
        vim.cmd "ObsidianYesterday"
      end,
      opts = { buffer = true },
      { desc = "obsidian Yesterday" },
    },
    ["<leader>oj"] = {
      action = function()
        vim.cmd "ObsidianToday"
      end,
      opts = { buffer = true },
      { desc = "obsidian jump to today" },
    },
    ["<leader>ot"] = {
      action = function()
        vim.cmd "ObsidianTemplate"
      end,
      opts = { buffer = true },
      { desc = "obsidian insert template" },
    },
    ["<leader>oi"] = {
      action = function()
        vim.cmd "ObsidianPasteImg"
      end,
      opts = { buffer = true },
      { desc = "obsidian paste image to default image path" },
    },

    ["<leader>oo"] = {
      action = function()
        vim.cmd "ObsidianOpen"
      end,
      opts = { buffer = true },
      { desc = "obsidian open note in app" },
    },
    ["<leader>ob"] = {
      action = function()
        vim.cmd "ObsidianBacklinks"
      end,
      opts = { buffer = true },
      { desc = "obsidian open note in app" },
    },
  },
  picker = {
    -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
    name = "telescope.nvim",
    -- Optional, configure key mappings for the picker. These are the defaults.
    -- Not all pickers support all mappings.
    mappings = {
      -- Create a new note from your query.
      new = "<C-x>",
      -- Insert a link to the selected note.
      insert_link = "<C-l>",
    },
  },
  -- Optional, configure additional syntax highlighting / extmarks.
  -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
  -- Specify how to handle attachments.
  attachments = {
    -- The default folder to place images in via `:ObsidianPasteImg`.
    -- If this is a relative path it will be interpreted as relative to the vault root.
    -- You can always override this per image by passing a full path to the command instead of just a filename.
    img_folder = "assets/imgs", -- This is the default

    -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
    ---@return string
    img_name_func = function()
      -- Prefix image names with timestamp.
      return string.format("%s-", os.time())
    end,

    -- A function that determines the text to insert in the note when pasting an image.
    -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
    -- This is the default implementation.
    -- -@param client obsidian.Client
    -- -@param path obsidian.Path the absolute path to the image file
    ---@return string
    img_text_func = function(client, path)
      path = client:vault_relative_path(path) or path
      return string.format("![%s](%s)", path.name, path)
    end,
  },
  ui = { enable = true },
}

function run_rclone_sync()
  vim.notify("Starting Obsidian sync...", vim.log.levels.INFO)
  local term = require "nvchad.term"
  local Terminal = term.toggle {
    pos = "vsp",
    cmd = "rclone sync /media/Library/obsidian-vaults gdrive:/Obsidian_vault",
    id = "rclone_sync",
    clear_cmd = false,
  }

  -- Get the job ID of the terminal
  local job_id = vim.b[Terminal.buf].terminal_job_id

  -- Set up autocmd to detect job completion
  vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*",
    callback = function(args)
      if args.buf == Terminal.buf then
        local success = vim.v.event.status == 0
        if success then
          vim.notify("Obsidian sync completed successfully!", vim.log.levels.INFO)
        else
          vim.notify("Obsidian sync failed!", vim.log.levels.ERROR)
        end
      end
    end,
  })
end
-- Obsidian sync to GDrive

vim.keymap.set(
  "n",
  "<Leader>os",
  ":lua run_rclone_sync()<CR>",
  { noremap = true, silent = true },
  { desc = "Sync Obsidian to GDrive" }
)

local wk = require "which-key"

wk.register({
  of = {
    function()
      return require("obsidian").util.gf_passthrough()
    end,
    "obsidian follow link",
  },
  od = {
    function()
      return require("obsidian").util.toggle_checkbox()
    end,
    "obsidian toggle checkbox",
  },
  oc = { ":ObsidianToggleCheckbox<CR>", "obsidian cycle checkbox" },
  on = { ":ObsidianNew<CR>", "obsidian new note" },
  oy = { ":ObsidianYesterday<CR>", "obsidian Yesterday" },
  oj = { ":ObsidianToday<CR>", "obsidian jump to today" },
  ot = { ":ObsidianTemplate<CR>", "obsidian insert template" },
  oi = { ":ObsidianPasteImg<CR>", "obsidian paste image to default image path" },
  oo = { ":ObsidianOpen<CR>", "obsidian open note in app" },
  ob = { ":ObsidianBacklinks<CR>", "obsidian open note in app" },
  os = { ":lua run_rclone_sync()<CR>", "Sync Obsidian to GDrive" },
}, { prefix = "<leader>", noremap = true, silent = true })

local api = require "image"
local Job = require "plenary.job"
local M = {}

function M.testRender(year, month, metric)
  print("received", year, month, metric)
  local tmp_file = "/tmp/test.png"
  -- Display the image using image.nvim
  local image = api.hijack_buffer(tmp_file, 0, 0, {
    id = "my_image_id", -- optional, defaults to a random string
    buffer = 500, -- optional, binds image to a buffer (paired with window binding)
    with_virtual_padding = true, -- optional, pads vertically with extmarks, defaults to false

    -- optional, binds image to an extmark which it follows. Forced to be true when
    -- `with_virtual_padding` is true. defaults to false.
    inline = true,
    -- geometry (optional)
    x = 1,
    y = 1,
    width = 50,
    height = 50,
  })
  image:render() -- render image
end

function M.display_habit_tracker(year, month, metric)
  Job:new({
    command = "node",
    args = { "/media/DevDrive/VaultCharts/dist/main.js", year, month, metric },
    on_exit = function(j, _)
      -- Create a temporary file to store the image
      local tmp_file = "/tmp/test.png"

      -- Display the image using image.nvim
      local image = api.from_file(tmp_file, {
        window = 0, -- current window
        inline = true,
        with_virtual_padding = true,
      })

      if image then
        image:render()
      else
        print "Error: Failed to load image from file"
      end
    end,
  }):start()
end

-- Command to call the function
vim.api.nvim_create_user_command("DisplayHabitTracker", function(opts)
  local year = tonumber(opts.args) or os.date "%Y"
  local month = tonumber(opts.fargs[2]) or os.date "%m"
  local metric = opts.fargs[3] or "did_journal?"
  M.testRender(year, month, metric)
  -- M.display_habit_tracker(year, month, metric)
end, { nargs = "*" })

return M
