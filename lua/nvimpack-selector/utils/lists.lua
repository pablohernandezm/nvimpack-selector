local M = {}

---Add an element between the elements of a list.
---@param list any[]
---@param element any | fun(item: any, index: integer): any
---@return any[]
M.intersperse = function(list, element)
  assert(type(list) == "table", "`list` must be a list")


  if #list == 0 then
    return {}
  end

  local new = {}

  for i, v in ipairs(list) do
    if i > 1 then
      table.insert(new, type(element) == "function" and element(v, i) or element)
    end

    table.insert(new, v)
  end

  return new
end

--- Surround a list with an element.
--- Add the element to the start and the end of the list.
--- @param list any[]
--- @param elstart any
--- @param elend any
--- @return any[]
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
