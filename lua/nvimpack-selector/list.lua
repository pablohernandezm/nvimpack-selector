local M = {}

---Extracts the value of the supported columna.
---@type table<selector_column, fun(pack: vim.pack.PlugData): string>
local ColumnHelper = {
  name = function(pack)
    return pack.spec.name
  end,
  rev = function(pack)
    return pack.rev
  end,
  src = function(pack)
    return pack.spec.src
  end
}

---Pad a string to fit the display settings.
---@param value string
---@param display column_display_settings
---@return string
local function pad_string(value, display)
  -- Initial string max width to 0
  local max_w = 0

  -- Extract the max width
  if type(display) == "number" then
    max_w = display
  elseif type(display) == "table" and type(display[1]) == "number" then
    max_w = display[1]
  end

  -- Nothing to process
  if max_w <= 0 then return "" end

  -- Default overflow values
  local overflow = "ellipsis"
  local overflow_text = "..."

  if type(display) == "table" then
    overflow = display[2]
  end

  if overflow == "cut" then
    overflow_text = ""
  end

  local val_len = vim.fn.strchars(value)

  -- Empty value: return spaces so columns remain aligned
  if val_len == 0 then
    return string.rep(" ", max_w)
  end

  -- Value too long: trim and add overflow indicator
  if val_len > max_w then
    local overflow_len = vim.fn.strchars(overflow_text)
    local keep = max_w - overflow_len
    if keep < 0 then
      keep = 0
    end
    -- Use strcharpart to correctly handle multibyte characters
    local trimmed = vim.fn.strcharpart(value, 0, keep) .. overflow_text
    return trimmed
  end

  -- Value fits: left-align and pad with spaces to fill column
  return value .. string.rep(" ", max_w - val_len)
end

---Get the formatted lines with information about the required columns.
---@param data ColumnOptions Line data array.
---@param max_width integer This should be the sum of all the expected columns width.
---@param line_formatter? fun(data: string[]):string Custom line formatter. Gets each column to return a string.
M.lines = function(data, max_width, line_formatter)
  local pack = require("nvimpack-selector.pack")

  ---Per column width
  ---@type integer[]
  local pc_width = {}

  local free_space = max_width
  local n_unset_space = 0

  for i = 1, #data.display do
    if free_space <= 0 then
      pc_width[i] = 0
      break
    end

    local d = data.display[i]
    local cw = 0
    if type(d) == "number" then
      cw = d
    elseif type(d[1]) == "number" then
      cw = d[1]
    end

    if cw < 0 then
      pc_width[i] = -1
      n_unset_space = n_unset_space + 1
    elseif cw < free_space then
      free_space = free_space - cw
      pc_width[i] = cw
    elseif cw >= free_space then
      pc_width[i] = cw - (cw - free_space)
      free_space = 0
      break
    end
  end

  ---Formatted lines
  ---@type string[][]
  local pack_data = {}

  for _, p in ipairs(pack.get()) do
    ---@type string[]
    local line = {}

    for i, v in ipairs(data.order) do
      if data.display[i] and ColumnHelper[v] and pc_width[i] then
        local value = ColumnHelper[v](p)
        local cw = pc_width[i]

        if free_space > 0 and cw < 0 then
          cw = n_unset_space > 0 and math.floor(free_space / n_unset_space) or 0
        end

        ---@type column_display_settings
        local d = data.display[i]
        if type(d) ~= "table" then
          d = cw
        elseif type(d[1]) == "number" then
          d[1] = cw
        end

        table.insert(line, pad_string(value, d))
      end
    end


    table.insert(pack_data, line)
  end

  ---@type string[]
  local result = {}
  for i, v in ipairs(pack_data) do
    if line_formatter then
      result[i] = line_formatter(v)
    else
      local line = ""
      for _, x in ipairs(v) do
        line = line .. x
      end

      result[i] = line
    end
  end

  return result
end

---Display the plugin list in `buff`.
---@param data ColumnOptions
---@param buff integer
---@param width integer
M.display = function(data, buff, width)
  local lines = M.lines(data, width)
  vim.api.nvim_buf_set_lines(buff, 0, -1, true, lines)
end

return M
