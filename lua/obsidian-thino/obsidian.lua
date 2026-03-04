local M = {}

--- Return the file path of today's daily note via obsidian.nvim.
--- Returns nil and emits an error notification if obsidian.nvim is unavailable.
--- @return string|nil
M.get_daily_note_path = function()
  local ok, daily = pcall(require, "obsidian.daily")
  if not ok then
    vim.notify("obsidian.nvim is not installed", vim.log.levels.ERROR)
    return
  end
  -- ref. https://github.com/obsidian-nvim/obsidian.nvim/blob/3094a93d1022f969cc297d2d261c56f5565cb3d6/lua/obsidian/daily/init.lua#L83
  local note = daily.today()
  if not note or not note.path then
    vim.notify("Failed to get today's daily note path", vim.log.levels.ERROR)
    return
  end
  return tostring(note.path)
end

return M
