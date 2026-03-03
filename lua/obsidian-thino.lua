local M = {}

local lazy = require("obsidian-thino.lazy")
local config = lazy.require("obsidian-thino.config")

M.setup = function(args)
  config.options = vim.tbl_deep_extend('force', config.defaults, args or {})
  lazy.require("obsidian-thino.utils").validate_recursive(config.schema, config.options)
  M.config = config
  vim.api.nvim_create_user_command("ThinoPost", lazy.require("obsidian-thino.thino").post, {
    desc = "Post to daily note",
  })
end

return M
