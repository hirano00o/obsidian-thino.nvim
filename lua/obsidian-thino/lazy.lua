local lazy = {}

--- Return a proxy table that lazily loads the given module on first access.
--- @param require_path string Module path passed to require()
--- @return table
lazy.require = function(require_path)
  return setmetatable({}, {
    __index = function(_, key) return require(require_path)[key] end,

    __newindex = function(_, key, value) require(require_path)[key] = value end,
  })
end

return lazy
