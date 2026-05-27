local M = {}

--- Get the available window width and the number of columns with dynamic width (negative values).
---@param settings nvimpack-selector.Config.Columns column settings.
---@param max_width integer Max width of the window.
---@return integer available_width Space not yet assigned to any column.
---@return integer negative_width_ctr Number of clumns with dynamic space (width < 0)
M.available_win_width = function(settings, max_width)
  --- Calculate each column width
  local available_width = max_width
  local neg_width_ctr = 0

  for _, v in pairs(settings) do
    if available_width <= 0 then
      break
    end

    local w = v.width or 0

    if w < 0 then
      neg_width_ctr = neg_width_ctr + 1
    elseif w > 0 then
      if available_width < w then
        w = w - (w - available_width)
      end

      available_width = available_width - w
    end
  end

  return available_width, neg_width_ctr
end

return M
