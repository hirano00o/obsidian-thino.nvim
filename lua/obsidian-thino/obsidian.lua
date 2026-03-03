local M = {}

local function get_obsidian_client()
  local ok, obsidian = pcall(require, "obsidian")
  if not ok then
    return nil, "obsidian.nvim is not installed"
  end

  local client_ok, client = pcall(obsidian.get_client)
  if not client_ok or not client then
    return nil, "obsidian.nvim client is not initialized"
  end

  return client, nil
end

--- Return the file path of today's daily note via the obsidian.nvim client.
--- Returns nil and emits an error notification if obsidian.nvim is unavailable.
--- @return string|nil
M.get_daily_note_path = function()
  local client, err = get_obsidian_client()
  if not client then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  local note = client:daily(0)
  return tostring(note.path)
end

return M
