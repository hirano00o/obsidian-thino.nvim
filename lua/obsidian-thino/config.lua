local M = {}

M.schema = {
  time_format = {
    type = "string",
    enum = {
      ["%H:%M"] = true,
      ["%H:%M:%S"] = true,
    }
  },
  itemize = {
    type = "string",
    enum = {
      list = "-",
      task = "- [ ]",
    }
  },
  popup_window = {
    type = "table",
    border = {
      type = "string",
      enum = {
        bold = true,
        double = true,
        none = true,
        rounded = true,
        shadow = true,
        single = true,
        solid = true,
      },
    },
    title = {
      type = "string",
    },
    title_pos = {
      type = "string",
      enum = {
        left = true,
        center = true,
        right = true,
      },
    },
    width_ratio = {
      type = "number",
      min = 0.1,
      max = 1.0,
    },
    height = {
      type = "number",
      min = 1,
    },
  },
}

M.defaults = {
  time_format = "%H:%M",
  itemize = "list",
  popup_window = {
    border = "rounded",
    title = "Thino (<C-CR> to post)",
    title_pos = "center",
    width_ratio = 0.6,
    height = 10,
  },
}

M.options = {}

--- Return the itemize symbol string for the current itemize option.
--- @return string
M.get_itemize_symbol = function()
  return M.schema.itemize.enum[M.options.itemize]
end

return M
