local M = {}

---Add an element between the elements of a list.
---@generic T: any
---@param list T[]
---@param element T | fun(index: integer, prev: T, next: T): T
---@return any[]
M.intersperse = function(list, element)
  assert(type(list) == "table", "`list` must be a list")

  if #list == 0 then
    return {}
  end

  local new = {}

  for i, v in ipairs(list) do
    if i > 1 then
      if type(element) == "function" then
        table.insert(new, element(i, list[i - 1], v))
      else
        table.insert(new, element)
      end
    end

    table.insert(new, v)
  end

  return new
end

--- Surround a list with an element.
--- Add the element to the start and the end of the list.
--- @generic T: any
--- @param list T[]
--- @param elstart T
--- @param elend T
--- @return T[]
M.surround = function(list, elstart, elend)
  assert(type(list) == "table", "`list` must be a list")

  local new = {}

  if elstart ~= nil then
    table.insert(new, elstart)
  end

  for _, v in ipairs(list) do
    table.insert(new, v)
  end

  if elend ~= nil then
    table.insert(new, elend)
  end

  return new
end

return M
