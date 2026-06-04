local M = {}

---@class nvimpack-selector.List.Item
---@field name string
---@field update fun()
---@field remove fun()

---@type nvimpack-selector.List.Item[]
local selection_list = {}

---@type integer
local max_len = 0

--- Display the list of plugins
---@param buffer integer
---@param max_width integer
M.display_list = function(buffer, max_width)
  selection_list = {}

  local columns = require("nvimpack-selector.config.internal").columns

  assert(vim.api.nvim_buf_is_valid(buffer), string.format("Buffer %d is not a valid buffer", buffer))
  assert(type(max_width) == "number", "Type of max_width must be a number")

  local disutils = require("nvimpack-selector.utils.display")
  local pack = require("nvimpack-selector.pack")
  local plugins = pack.get()
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
    --- set lines
    local start = (i - 1) + row_start
    local stop = i + row_start

    ---@param plug vim.pack.PlugData
    local setLine = function(plug)
      local pair = colutils.apply_column_settings(plug, columns_cpy)
      local line = ""
      for _, p in ipairs(pair) do
        line = line .. p.value
      end

      vim.api.nvim_buf_set_lines(buffer, start, stop, false, { line })

      return pair
    end

    ---@type table<"ns" | "id", integer>[]
    local extmarks = {}

    ---@param pair nvimpack-selector.utils.ColumnValuePair[]
    local setHl = function(pair)
      vim.schedule(function()
        local col_start = 0

        for _, p in ipairs(pair) do
          ---@type nvimpack-selector.Config.Columns.Opts
          local col = columns[p.name]

          if col.hl_group then
            local ns_name = "nvimpack-selector.list." .. p.name
            local ns = vim.api.nvim_get_namespaces()[ns_name]
            ns = ns or vim.api.nvim_create_namespace(ns_name)

            local id = vim.api.nvim_buf_set_extmark(buffer, ns, start, col_start, {
              end_col = col_start + vim.trim(p.value):len(),
              hl_group = col.hl_group,
            })

            table.insert(extmarks, { ns = ns, id = id })
          end

          col_start = col_start + col.width
        end
      end)
    end

    setHl(setLine(plugin))

    local removeExtMarks = function()
      for _, mark in ipairs(extmarks) do
        vim.api.nvim_buf_del_extmark(buffer, mark.ns, mark.id)
      end
    end

    local idx = i
    local plug = plugin
    selection_list[idx] = {
      name = plugin.spec.name,
      update = function()
        if vim.api.nvim_buf_is_valid(buffer) then
          removeExtMarks()
          local uplugin = pack.get({ plug.spec.name })

          if #uplugin == 0 then
            M.remove(idx)
          elseif uplugin[1] then
            setHl(setLine(uplugin[1]))
          end
        end
      end,
      remove = function()
        if vim.api.nvim_buf_is_valid(buffer) then
          removeExtMarks()

          local ns_name = "nvimpack-selector.list.removed"
          local ns = vim.api.nvim_get_namespaces()[ns_name]
          ns = ns or vim.api.nvim_create_namespace(ns_name)

          local line = vim.api.nvim_buf_get_lines(buffer, start, start + 1, false)[1]
          vim.api.nvim_buf_set_extmark(buffer, ns, start, 0, {
            end_col = line and #line or 0,
            hl_group = "Ignore",
            hl_eol = true,
          })

          selection_list[idx] = nil
        end
      end,
    }
  end

  max_len = #plugins
end

--- Get the idx element of the list
---@param idx integer index
M.get = function(idx)
  vim.validate("idx", idx, "number")
  vim.validate("idx", idx, function(v)
    return v > 0 and v <= max_len
  end, "valid index")

  return selection_list[idx]
end

--- Find the index of a plugin
---@param name string
---@return nil | {[1]: integer, [2]: nvimpack-selector.List.Item} (index, item)
M.find = function(name)
  for i = 1, max_len do
    if selection_list[i] and selection_list[i].name == name then
      return { i, selection_list[i] }
    end
  end

  return nil
end

--- Remove idx element of the list
---@param idx integer index
M.remove = function(idx)
  vim.validate("idx", idx, "number")
  vim.validate("idx", idx, function(v)
    return v > 0 and v <= max_len
  end, "valid index")

  local item = selection_list[idx]
  if item then
    item.remove()
  end
end

--- Update idx element in the list
---@param idx integer index
M.update = function(idx)
  vim.validate("idx", idx, "number")
  vim.validate("idx", idx, function(v)
    return v > 0 and v <= max_len
  end, "valid index")

  local item = selection_list[idx]
  if item then
    item.update()
  end
end

return M
