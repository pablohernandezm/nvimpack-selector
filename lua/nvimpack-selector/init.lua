local M = {}

---@param opts? nvimpack-selector.Opts
M.setup = function(opts)
  vim.g.nvimpack_selector = opts
end

return M
