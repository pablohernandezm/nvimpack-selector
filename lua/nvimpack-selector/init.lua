local M = {
  settings = nil
}

local win_data = {
  buf = -1,
  win = -1
}

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
  }
}

M.setup = function(opts)
  M.settings = vim.tbl_deep_extend("force", defaults, opts)
end

M.open = function()
  win_data.buf, win_data.win = require("nvimpack-selector.ui").open_float(M.settings and M.settings.ui or defaults.ui)

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
