---@class Settings
local defaults = {
  ---@class UIOptions
  ui = {
    min_width = 50,
    min_height = 20,
    title = "Pack selector",
    footer = {
      { "[u] update", "DiagnosticFloatingInfo" },
      { " " },
      { "[c] clear",  "DiagnosticFloatingHint" },
      { " " },
      { "[d] delete", "DiagnosticFloatingWarn" },
    },

    --- Calculated the first time the window is open based ui.min_width and columns.width.
    ---@private
    ---@type integer | nil
    _width = nil,
  },
  ---@class ColumnOptions
  columns = {
    ---Columns to display and their order.
    ---@alias selector_column "name" | "rev" | "src"
    ---@type selector_column[]
    order = { "name", "rev", "src" },

    ---@alias column_display_settings integer | {[1]:integer; [2]:"ellipsis"|"cut"}
    --- Display options for each column based on the order they are displayed.
    --- Negative value make the column fills the available space.
    --- Non specified values are set to -1 automatically.
    --- If you want to hide a column that is in order, give it a width of 0.
    --- Optionally you can set a display value with an array with two values: an integer and an overflow setting.
    --- Note that this values may affect the size of the windows if the sum is bigger than the provided in the ui options.
    --- @type column_display_settings[]
    display = { 20, { 7, "cut" }, -1 },
  }
}

local M = {
  settings = defaults
}

local win_data = {
  buf = -1,
  win = -1
}

---@param opts Settings
M.setup = function(opts)
  M.settings = vim.tbl_deep_extend("force", M.settings, opts)
end

M.open = function()
  --Calculate the window width
  if not M.settings.ui._width then
    M.settings.ui._width = math.max(M.settings.ui.min_width, (function()
      local sum = 0

      for _, d in pairs(M.settings.columns.display) do
        sum = sum + (type(d) == "number" and d or d[1])
      end

      return sum
    end)())
  end

  --Open the floating window
  win_data.buf, win_data.win = require("nvimpack-selector.ui").open_float(nil, M.settings.ui)


  --Display the selector
  require("nvimpack-selector.list").display(M.settings.columns, win_data.buf, M.settings.ui._width)

  --Reset win_data when closed
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win_data.win),
    once = true,
    callback = function()
      win_data.win = -1
      win_data.buf = -1
    end
  })

  return win_data.win, win_data.buf
end

---@return nil | integer
---@return nil | integer
M.toggle = function()
  if vim.api.nvim_win_is_valid(win_data.win) then
    vim.api.nvim_win_close(win_data.win, false)
  else
    return M.open()
  end
end

return M
