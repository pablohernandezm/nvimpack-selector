local M = {}

---@alias Footer string[]

---@class WindowOptions
---@field buffer? integer
---@field h integer
---@field w integer
---@field title string
---@field footer Footer[]

---Create a centered floating window
---@param opts WindowOptions
---@return integer buffer
---@return integer window
M.open_float = function(opts)
  local buf = opts.buffer or vim.api.nvim_create_buf(false, true)

  local win_id = vim.api.nvim_open_win(buf, true, {
    height = opts.h,
    width = opts.w,
    relative = "editor",
    col = math.floor((vim.o.columns - opts.w) / 2),
    row = math.floor((vim.o.lines - opts.h) / 2),
    style = "minimal",
    border = "rounded",
    title = opts.title,
    footer = opts.footer,
  })

  return buf, win_id
end

return M
