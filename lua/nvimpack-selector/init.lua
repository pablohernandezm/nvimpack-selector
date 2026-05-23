---@class Settings
local defaults = {
  ---@class UIOptions
  ui = {
    ---Minimum window width.
    min_width = 50,
    ---Minimum window height.
    min_height = 20,
    ---Window title.
    title = "Pack selector",

    ---Footer is an array of entries shown on the floating window footer.
    ---By default it shows the window keymaps.
    ---Each entry may be:
    --- - a plain string, e.g. { " " }
    --- - an array: { "text", "HighlightGroup" }
    footer = {
      { "[u] update", "DiagnosticFloatingInfo" },
      { " " },
      { "[c] clear",  "DiagnosticFloatingHint" },
      { " " },
      { "[d] delete", "DiagnosticFloatingWarn" },
    },

    ---Calculated the first time the window is open based ui.min_width and columns.width.
    ---@private
    ---@type integer | nil
    _width = nil,
  },
  ---@class ColumnOptions
  columns = {
    ---Which columns to display and in what order
    ---@alias selector_column "name" | "rev" | "src"
    ---@type selector_column[]
    order = { "name", "rev", "src" },

    ---@alias column_display_settings
    ---| integer The column fixed width.
    ---| {[1]:integer; [2]:"ellipsis"|"cut"} The column fixed width and the overflow handling mode.

    ---Display options for each column based on the order they are displayed.
    ---Negative value make the column fills the available space.
    ---Non specified values are set to -1 automatically.
    ---If you want to hide a column that is in order, give it a width of 0.
    ---Optionally you can set a display value with an array with two values: an integer and an overflow setting.
    ---Note that this values may affect the size of the windows if the sum is bigger than the provided in the ui options.

    ---How to display each column (corresponds to `order`).
    ---Each entry can be:
    --- - an integer: fixed width, e.g. 20
    --- - a negative integer (e.g. -1): fill remaining space
    --- - 0: hide the column
    --- - an array: { width, "ellipsis" | "cut" } where the second element controls overflow display
    ---
    ---Please note that this values may affect window size if the sum is greater than the provided in the ui options.
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

---Open the selector.
---@return integer window The window id
---@return integer buffer The buffer id
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

---Toggle the selector.
---@return nil | integer window The window id
---@return nil | integer buffer The buffer id
M.toggle = function()
  if vim.api.nvim_win_is_valid(win_data.win) then
    vim.api.nvim_win_close(win_data.win, false)
  else
    return M.open()
  end
end

return M
