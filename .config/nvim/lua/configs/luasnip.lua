local ls = require "luasnip"

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- #####################################################################
--                            Markdown
-- #####################################################################

-- Helper function to create code block snippets
local function create_code_block_snippet(lang)
  return s({
    trig = lang,
    name = "Codeblock",
    desc = lang .. " codeblock",
  }, {
    t { "```" .. lang, "" },
    i(1),
    t { "", "```" },
  })
end

-- Define languages for code blocks
local languages = {
  "txt",
  "lua",
  "rust",
  "sql",
  "go",
  "elixir",
  "regex",
  "bash",
  "markdown",
  "markdown_inline",
  "yaml",
  "json",
  "jsonc",
  "cpp",
  "csv",
  "java",
  "javascript",
  "typescript",
  "python",
  "dockerfile",
  "html",
  "css",
  "templ",
  "php",
}

local snippets = {}
for _, lang in ipairs(languages) do
  table.insert(snippets, create_code_block_snippet(lang))
end

-- Paste clipboard contents in link section, move cursor to ()
local function clipboard()
  return vim.fn.getreg "+"
end

table.insert(
  snippets,
  s({
    trig = "linkcex",
    name = "Paste clipboard as EXT .md link",
    desc = "Paste clipboard as EXT .md link",
  }, {
    t "[",
    i(1),
    t "](",
    f(clipboard, {}),
    t '){:target="_blank"}',
  })
)
--image link
table.insert(
  snippets,
  s({
    trig = "img",
    name = "Image link",
    desc = "Insert image with alt text and source",
  }, {
    t "![",
    i(1, "alt text"),
    t "](",
    i(2, "image_url"),
    t ")",
  })
)

ls.add_snippets("markdown", snippets)
