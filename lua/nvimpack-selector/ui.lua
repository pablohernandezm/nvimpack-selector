local M = {}

---@alias Footer string[]


---Create a centered floating window.
---@param buffer nil | integer
---@param opts UIOptions
---@return integer buffer
---@return integer window
M.open_float = function(buffer, opts)
  buffer = buffer and buffer or vim.api.nvim_create_buf(false, true)
  local w = opts._width and opts._width or opts.min_width
  local h = opts.min_height

  if w == 0 or h == 0 then
    error("Height and width should be set")
  end

  local win_id = vim.api.nvim_open_win(buffer, true, {
    height = h,
    width = w,
    relative = "editor",
    col = math.floor((vim.o.columns - w) / 2),
    row = math.floor((vim.o.lines - h) / 2),
    style = "minimal",
    border = "rounded",
    title = opts.title,
    footer = opts.footer,
  })

  return buffer, win_id
end

return M
