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

  local colutils = require("nvimpack-selector.utils.columns")

  local row_start = 0
  for i, plugin in ipairs(plugins) do
    local pair = colutils.apply_column_settings(plugin, columns_cpy)

    --- set lines
    local start = (i - 1) + row_start
    local stop = i + row_start
    local line = ""

    for _, p in ipairs(pair) do
      line = line .. p.value
    end

    vim.api.nvim_buf_set_lines(buffer, start, stop, false, { line })

    --- set column highlights
    vim.schedule(function()
      local col_start = 0

      for _, p in ipairs(pair) do
        ---@type nvimpack-selector.Config.Columns.Opts
        local col = columns[p.name]

        if col.hl_group then
          local ns_name = "nvimpack-selector.list." .. p.name
          local ns = vim.api.nvim_get_namespaces()[ns_name]
          ns = ns or vim.api.nvim_create_namespace(ns_name)

          vim.api.nvim_buf_set_extmark(buffer, ns, start, col_start, {
            end_col = col_start + vim.trim(p.value):len(),
            hl_group = col.hl_group,
          })
        end

        col_start = col_start + col.width
      end
    end)
  end
end

return M
