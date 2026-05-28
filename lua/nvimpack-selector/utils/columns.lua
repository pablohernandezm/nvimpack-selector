local M = {}

--- Sort columns by priority. Higher priorities go first.
---@param opts nvimpack-selector.Config.Columns
---@return {[1]: nvimpack-selector.Config.Column, [2]: nvimpack-selector.Config.Columns.Opts}[]
M.sort_columns = function(opts)
  local sorted = {}
  if not opts then
    return sorted
  end

  for k, v in pairs(opts) do
    table.insert(sorted, { k, v })
  end

  table.sort(sorted, function(a, b)
    return a[2].priority > b[2].priority
  end)

  return sorted
end

---Format a column value based on the width and column options.
---@param value string
---@param options nvimpack-selector.Config.Columns.Opts
M.format_column = function(value, options)
  local text = value

  if options.value_formatter and type(options.value_formatter) == "function" then
    text = options.value_formatter(value)
    assert(type(text) == "string", "`value_formatter` should return a string")
  end

  if value:len() > options.width then
    local overflow_text = options.overflow

    if options.overflow == "cut" then
      overflow_text = ""
    elseif options.overflow == "ellipsis" then
      overflow_text = "..."
    end

    text = string.sub(text, 1, options.width - overflow_text:len()) .. overflow_text
  end

  return string.format("%" .. -options.width .. "s", text)
end

---Process and order plugin data based on column settings.
---@param data vim.pack.PlugData Plugin data.
---@param opts nvimpack-selector.Config.Columns Column config.
---@return string[]
M.apply_column_settings = function(data, opts)
  local sorted = M.sort_columns(opts)

  local packutils = require("nvimpack-selector.utils.pack")
  local result = {}
  for i = 1, #sorted do
    local col_name = sorted[i][1]
    local col_config = sorted[i][2]
    local col_value = packutils.extract_property(col_name, data)

    assert(col_value, string.format("Unexpected column %s", col_name))

    result[i] = M.format_column(col_value, col_config)
  end

  return result
end
return M
