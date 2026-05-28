local M = {}

--- Display the list of plugins
---@param buffer integer
---@param max_width integer
M.display_list = function(buffer, max_width)
  local columns = require("nvimpack-selector.config.internal").columns

  assert(vim.api.nvim_buf_is_valid(buffer), string.format("Buffer %d is not a valid buffer", buffer))
  assert(type(max_width) == "number", "Type of max_width must be a number")

  local disutils = require("nvimpack-selector.utils.display")
  local plugins = require("nvimpack-selector.pack").get()
  local available_width, neg_width_ctr = disutils.available_win_width(columns, max_width)

  ---@type nvimpack-selector.Config.Columns
  local columns_cpy = vim.deepcopy(columns, true)

  for _, c in pairs(columns_cpy) do
    ---@type nvimpack-selector.Opts.Columns.Opts
    c = c

    if neg_width_ctr == 0 or available_width == 0 then
      break
    end

    if c.width < 0 then
      c.width = math.floor(available_width / neg_width_ctr)
    end
  end

  ---@type string[]
  local lines = {}
  local colutils = require("nvimpack-selector.utils.columns")

  for _, plugin in ipairs(plugins) do
    local processed = colutils.apply_column_settings(plugin, columns_cpy)
    table.insert(lines, table.concat(processed))
  end

  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
end

return M
