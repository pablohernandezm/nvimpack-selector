local M = {}

---Extract a property from a plugin data.
---@param property nvimpack-selector.Config.Column
---@param data vim.pack.PlugData
M.extract_property = function(property, data)
  if not data or not property then
    return nil
  end

  if property == "rev" then
    return data.rev
  else
    if property == "name" then
      return data.spec.name
    elseif property == "src" then
      return data.spec.src
    end
  end
end

return M
