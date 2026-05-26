local M = {}

---@param opts? nvimpack-selector.Opts
M.setup = function(opts)
  vim.g.nvimpack_selector = opts
end

M.getConf = function()
  return require("nvimpack-selector.config.internal")
end

--- Open list in a floating window.
---@return integer buffer
---@return integer window
M.open_float = function()
  ---@as vim.api.keyset.win_config
  local config = M.getConf()
  local w = config.window.min_width
  local h = config.window.min_height

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    col = math.floor((vim.o.columns - w) / 2),
    row = math.floor((vim.o.lines - h) / 2),
    width = w,
    height = h,
    unpack(config)
  })

  return buf, win
end

return M
