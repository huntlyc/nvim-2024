local sorters = require "telescope.sorters"

local M = {}

-- Splits a prompt on a double space into a fuzzy search term and an
-- optional file extension filter, e.g. "block  .tsx" -> "block", "tsx"
local function split_prompt(prompt)
  local pieces = vim.split(prompt or "", "  ")
  local search = pieces[1] or ""
  local ext = pieces[2]
  if ext then
    ext = vim.trim(ext):gsub("^%.", "")
  end
  return search, ext
end

-- Wraps a telescope sorter so that the extension piece of the prompt
-- (see split_prompt) filters entries by filename suffix, while the search
-- piece is forwarded to the wrapped sorter as normal.
local function ext_filter_sorter(inner)
  return sorters.Sorter:new {
    init = function()
      inner:_init()
    end,
    destroy = function()
      inner:_destroy()
    end,
    start = function(_, prompt)
      local search = split_prompt(prompt)
      inner:_start(search)
    end,
    finish = function(_, prompt)
      local search = split_prompt(prompt)
      inner:_finish(search)
    end,
    score = function(_, prompt, entry, cb_add, cb_filter)
      local search, ext = split_prompt(prompt)
      if ext and ext ~= "" then
        local ordinal = (entry.ordinal or ""):lower()
        if not ordinal:match("%." .. vim.pesc(ext:lower()) .. "$") then
          return cb_filter(entry)
        end
      end
      return inner:score(search, entry, cb_add, cb_filter)
    end,
    highlighter = function(_, prompt, display)
      local search = split_prompt(prompt)
      return inner:highlighter(search, display)
    end,
  }
end

local function with_ext_filter(picker)
  return function(opts)
    opts = opts or {}
    local conf = require "telescope.config".values
    opts.sorter = ext_filter_sorter(conf.file_sorter(opts))
    picker(opts)
  end
end

M.setup = function()
  local builtin = require "telescope.builtin"
  vim.keymap.set("n", "<leader>ff", with_ext_filter(builtin.git_files), { desc = "Git files" })
  vim.keymap.set("n", "<leader>fF", with_ext_filter(builtin.find_files), { desc = "Find all files" })
end

return M
