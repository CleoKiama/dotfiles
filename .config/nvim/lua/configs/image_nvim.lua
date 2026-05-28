require("image").setup({
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = true,
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      resolve_image_path = function(document_path, image_path, fallback)
        local base_path = vim.g.vault_path .. "/"

        -- Expand paths to handle special characters
        local expanded_document_path = vim.fn.expand(document_path)
        local expanded_image_path = vim.fn.expand(image_path)


        -- Check if the document is in the specific vault directory
        if vim.fn.fnamemodify(expanded_document_path, ":p"):find(base_path, 1, true) then
          -- If the document is in the vault, use the custom base path
          local finalPath = base_path .. expanded_image_path
          return finalPath
        else
          -- Otherwise, use the default fallback behavior
          return fallback(document_path, image_path)
        end
      end,
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = true,
      filetypes = { "norg" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  kitty_method = "normal",
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 100,
  window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  editor_only_render_when_focused = false,                                            -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = true,                                             -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})
