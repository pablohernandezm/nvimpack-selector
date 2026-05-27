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
    style = "minimal",
    border = "rounded",
    title = config.window.title.text,
    title_pos = config.window.title.position,
    footer = require("nvimpack-selector.utils.lists").intersperse(
      config.window.footer.entries,
      { config.window.footer.separator }
    ),
    footer_pos = config.window.footer.position,
  })

  require("nvimpack-selector.list").display_list(buf, w)

  return buf, win
end

return M
