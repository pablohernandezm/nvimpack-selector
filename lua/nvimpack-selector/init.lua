local M = {}

---@type integer | nil
local buf = nil
---@type integer | nil
local win = nil

---@param opts? nvimpack-selector.Opts
M.setup = function(opts)
  vim.g.nvimpack_selector = opts
end

M.getConf = function()
  return require("nvimpack-selector.config.internal")
end

---Get the selected item and it's index in the list (item, row).
---@return nvimpack-selector.List.Item | nil
---@return integer | nil
M.getSelected = function()
  if win then
    vim.validate("window", win, vim.api.nvim_win_is_valid, "valid window")

    local row = vim.api.nvim_win_get_cursor(win)[1]
    return require("nvimpack-selector.list").get(row), row
  end

  return nil
end

---@param bufnr integer
local loadKeymaps = function(bufnr)
  local config = M.getConf().keymaps

  for key, action in pairs(config) do
    vim.keymap.set("n", key, function()
      action()
    end, { buf = bufnr })
  end
end

--- Open list in a floating window.
---@return integer buffer
---@return integer window
M.open_float = function()
  local config = M.getConf()

  local w = config.window.min_width
  local h = config.window.min_height

  buf = vim.api.nvim_create_buf(false, true)
  win = vim.api.nvim_open_win(buf, true, {
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

  --- window style
  vim.wo[win].cursorline = true

  --- keymaps
  loadKeymaps(buf)

  --- return
  return buf, win
end

return M
