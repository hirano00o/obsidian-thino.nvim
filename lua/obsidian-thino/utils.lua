local M = {}

local plugin_name = "obsidian-thino.nvim"

local function validate_item(rule, value, path)
  if value == nil then return end

  -- type check
  if type(value) ~= rule.type then
    error(string.format("[%s] %s must be %s, got %s", plugin_name, path, rule.type, type(value)))
  end

  -- enum check
  if rule.enum and not rule.enum[value] then
    local allowed = table.concat(vim.tbl_keys(rule.enum), ", ")
    error(string.format("[%s] Invalid %s: '%s'. Expected: %s", plugin_name, path, value, allowed))
  end

  -- number range check
  if rule.type == "number" then
    if rule.min ~= nil and rule.min > value then
      error(string.format("[%s] %s must be %f or greater, got %f", plugin_name, path, rule.min, value))
    end
    if rule.max ~= nil and rule.max < value then
      error(string.format("[%s] %s must be less than or equal %f, got %f", plugin_name, path, rule.max, value))
    end
  end
end

--- Recursively validate config values against the given schema.
--- Raises an error if any value has the wrong type, is outside its enum, or violates min/max.
--- @param schema table Schema definition table
--- @param config table Config values to validate
--- @param path? string Dot-separated key path used in error messages (default: "")
M.validate_recursive = function(schema, config, path)
  path = path or ""

  for key, rule in pairs(schema) do
    -- skip attribute (type, enum, min, max)
    if key ~= "type" and key ~= "enum" and key ~= "min" and key ~= "max" then
      local value = config[key]
      local current_path = path == "" and key or (path .. "." .. key)

      -- check by item
      validate_item(rule, value, current_path)

      -- recursive if table
      if rule.type == "table" and value ~= nil then
        M.validate_recursive(rule, value, current_path)
      end
    end
  end
end

return M
