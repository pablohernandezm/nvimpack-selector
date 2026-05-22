---@alias selector_column "name" | "rev" | "src"

local defaults = {
  ui = {
    w = 50,
    h = 20,
    title = "Pack selector",
    footer = {
      { "[u] update", "DiagnosticFloatingInfo" },
      { " " },
      { "[c] clear",  "DiagnosticFloatingHint" },
      { " " },
      { "[d] delete", "DiagnosticFloatingWarn" },
    }
  },
  columns = {
    --- Columns to display and their order.
    ---@type selector_column[]
    order = { "name", "rev", "src" },

    --- Width of each column based on the order they are displayed.
    --- Negative value make the column fills the available space.
    --- Non specified values takes -1 automatically.
    --- If you want to hide a column that is in order, give it a width of 0.
    --- Note that this values may affect the size of the windows if the sum is bigger than the provided in the ui options.
    ---@type integer[]
    width = { 20, 7 },
  }
}

local M = {
  settings = defaults
}

local win_data = {
  buf = -1,
  win = -1
}

M.setup = function(opts)
  M.settings = vim.tbl_deep_extend("force", M.settings, opts)
end

M.open = function()
  win_data.buf, win_data.win = require("nvimpack-selector.ui").open_float(M.settings.ui)

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
