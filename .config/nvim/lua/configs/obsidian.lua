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
      { desc = "[p] obsidian follow link" },
    },
    -- Toggle check-boxes "obsidian done"
    ["<leader>od"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian toggle checkbox" },
    },
    ["<leader>oc"] = {
      action = function()
        vim.cmd " ObsidianToggleCheckbox"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian cycle checkbox" },
    },
    ["<leader>or"] = {
      action = function()
        vim.cmd "ObsidianTomorrow"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian jump to tomorrow" },
    },
    ["<leader>on"] = {
      action = function()
        vim.cmd "ObsidianNew"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian new note" },
    },

    ["<leader>oy"] = {
      action = function()
        vim.cmd "ObsidianYesterday"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian Yesterday" },
    },
    ["<leader>oj"] = {
      action = function()
        vim.cmd "ObsidianToday"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian jump to today" },
    },
    ["<leader>ot"] = {
      action = function()
        vim.cmd "ObsidianTemplate"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian insert template" },
    },
    ["<leader>oi"] = {
      action = function()
        vim.cmd "ObsidianPasteImg"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian paste image to default image path" },
    },

    ["<leader>oo"] = {
      action = function()
        vim.cmd "ObsidianOpen"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian open note in app" },
    },
    ["<leader>ob"] = {
      action = function()
        vim.cmd "ObsidianBacklinks"
      end,
      opts = { buffer = true },
      { desc = "[p] obsidian open note in app" },
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
  term.toggle {
    pos = "vsp",
    cmd = "rclone sync /media/Library/obsidian-vaults gdrive:/Obsidian_vault",
    id = "rclone_sync",
    clear_cmd = false,
  }
end

-- Obsidian sync to GDrive

vim.keymap.set("n", "<Leader>os", ":lua run_rclone_sync()<CR>", { desc = "Sync Obsidian to GDrive" })

local wk = require "which-key"

wk.add {
  {
    mode = { "n" },
    {
      "<leader>o",
      {
        f = {
          function()
            return require("obsidian").util.gf_passthrough()
          end,
          "obsidian follow link",
        },
        d = {
          function()
            return require("obsidian").util.toggle_checkbox()
          end,
          "obsidian toggle checkbox",
        },
        c = { ":[p]ObsidianToggleCheckbox<CR>", "obsidian cycle checkbox" },
        n = { ":[p]ObsidianNew<CR>", "obsidian new note" },
        y = { ":[p]ObsidianYesterday<CR>", "obsidian Yesterday" },
        j = { ":[p]ObsidianToday<CR>", "obsidian jump to today" },
        t = { ":[p]ObsidianTemplate<CR>", "obsidian insert template" },
        i = { ":[p]ObsidianPasteImg<CR>", "obsidian paste image to default image path" },
        o = { ":[p]ObsidianOpen<CR>", "obsidian open note in app" },
        b = { ":[p]ObsidianBacklinks<CR>", "obsidian open note in app" },
        s = { ":[p]lua run_rclone_sync()<CR>", "Sync Obsidian to GDrive" },
      },
      group = "Obsidian",
    },
  },
}

require "configs.task_manager"
