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
  local config = vim.tbl_deep_extend("force", {}, M.getConf())

  local w = config.window.min_width
  local h = config.window.min_height

  ---@type vim.api.keyset.win_config
  local float_opts = {
    relative = "editor",
    col = math.floor((vim.o.columns - w) / 2),
    row = math.floor((vim.o.lines - h) / 2),
    width = w,
    height = h,
    style = "minimal",
    border = "rounded",
    title_pos = "left",
  }

  -- Remove custom window options
  config.window.min_width = nil
  config.window.min_height = nil

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, vim.tbl_deep_extend("keep", float_opts, config.window))

  return buf, win
end

return M
