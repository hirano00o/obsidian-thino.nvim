local M = {}

local lazy = require("obsidian-thino.lazy")
local config = lazy.require("obsidian-thino.config")

local function create_input_window(buf)
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })

  -- Calculate window size and position (centered)
  local option = config.options.popup_window
  local width = math.floor(vim.o.columns * option.width_ratio)
  local height = option.height
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = option.border,
    title = option.title,
    title_pos = option.title_pos,
  })

  -- Set window options
  vim.api.nvim_set_option_value("wrap", true, { win = win })
  vim.api.nvim_set_option_value("linebreak", true, { win = win })

  return win
end

local function close_window(win)
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  vim.cmd("stopinsert")
end

local function format_content(lines)
  -- Filter out empty lines
  local content_lines = vim.tbl_filter(function(line)
    return line ~= ""
  end, lines)

  if #content_lines == 0 then
    return nil
  end

  local time = os.date(config.options.time_format)
  local formatted_lines = {}

  for i, line in ipairs(content_lines) do
    if i == 1 then
      -- First line: timestamp + content
      local symbol = config.get_itemize_symbol()
      table.insert(formatted_lines, string.format("%s %s %s", symbol, time, line))
    else
      -- Subsequent lines: 2-space indent
      table.insert(formatted_lines, "  " .. line)
    end
  end

  return table.concat(formatted_lines, "\n") .. "\n"
end

local OBSIDIAN_TO_STRFTIME = {
  YYYY = "%%Y",
  YY = "%%y",
  MM = "%%m",
  DD = "%%d",
  HH = "%%H",
  mm = "%%M",
  ss = "%%S",
  ddd = "%%a",
  dddd = "%%A",
}

local function convert_to_strftime(obsidian_format)
  local result = obsidian_format
  -- Sort by length descending to match longer patterns first (e.g., "dddd" before "ddd")
  local sorted_keys = {}
  for k in pairs(OBSIDIAN_TO_STRFTIME) do
    table.insert(sorted_keys, k)
  end
  table.sort(sorted_keys, function(a, b)
    return #a > #b
  end)

  for _, key in ipairs(sorted_keys) do
    result = result:gsub(key, OBSIDIAN_TO_STRFTIME[key])
  end
  -- Remove double percent signs added for gsub escaping
  result = result:gsub("%%%%", "%%")
  return result
end

local function substitute_parameterized_vars(text)
  -- Match {{date:FORMAT}} pattern
  text = text:gsub("{{date:([^}]+)}}", function(format)
    local strftime_format = convert_to_strftime(format)
    return os.date(strftime_format)
  end)

  -- Match {{time:FORMAT}} pattern
  text = text:gsub("{{time:([^}]+)}}", function(format)
    local strftime_format = convert_to_strftime(format)
    return os.date(strftime_format)
  end)

  return text
end

local function process_template_vars(file_path)
  -- Read file content
  local file = io.open(file_path, "r")
  if not file then
    return
  end
  local content = file:read("*a")
  file:close()

  -- Check if there are any parameterized variables to process
  if not content:match("{{[^}]+:[^}]+}}") then
    return
  end

  -- Substitute variables
  local processed = substitute_parameterized_vars(content)

  -- Write back if changed
  if processed ~= content then
    file = io.open(file_path, "w")
    if file then
      file:write(processed)
      file:close()
    end
  end
end

local function submit_post(buf, win, daily_note_path)
  -- Get buffer content
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local formatted = format_content(lines)

  -- Close window first
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  vim.cmd("stopinsert")

  -- Return if no content
  if not formatted then
    return
  end

  -- Process parameterized template variables
  process_template_vars(daily_note_path)

  -- Append to daily note
  local file, open_err = io.open(daily_note_path, "a")
  if not file then
    vim.notify("Failed to open daily note: " .. (open_err or "unknown error"), vim.log.levels.ERROR)
    return
  end

  file:write(formatted)
  file:close()

  vim.schedule(function()
    vim.notify("Posted to " .. daily_note_path, vim.log.levels.INFO)
  end)
end

--- Open a floating input window and append the entered text to today's daily note.
--- Keymaps: <C-CR> to submit, q to cancel.
M.post = function()
  local path = lazy.require("obsidian-thino.obsidian").get_daily_note_path()
  if not path then
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local win = create_input_window(buf)

  -- Set up keymaps for this buffer
  local opts = { buffer = buf, noremap = true, silent = true }

  -- Submit: Ctrl+Enter (works in both normal and insert mode)
  vim.keymap.set({ "n", "i" }, "<C-CR>", function() submit_post(buf, win, path) end, opts)

  -- Cancel: q (normal mode only)
  vim.keymap.set("n", "q", function() close_window(win) end, opts)

  -- Start in insert mode
  vim.cmd("startinsert")
end

return M
