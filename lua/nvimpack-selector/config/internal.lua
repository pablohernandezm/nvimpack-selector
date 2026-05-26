---@class nvimpack-selector.Config
local default_config = {
  ---@class nvimpack-selector.Config.Window
  window = {
    ---Minimum window width.
    ---@type integer
    min_width = 50,
    ---Minimum window height.
    ---@type integer
    min_height = 20,
    ---Window title.
    ---@type string
    title = "Pack selector",
    --- Footer is an array of entries shown on the floating window footer.
    --- By default it shows the window keymaps.
    --- Each entry may be:
    --- - a plain string, e.g. { " " }
    --- - an array: { "text", "HighlightGroup" }
    ---@alias nvimpack-selector.Window.Footer({ [1]: string, [2]: string? })[]
    ---@type nvimpack-selector.Window.Footer
    footer = {
      { "[u] update", "DiagnosticFloatingInfo" },
      { "[c] clear",  "DiagnosticFloatingHint" },
      { "[d] delete", "DiagnosticFloatingWarn" }
    }
  }
}

local gs = vim.g.nvimpack_selector or {}
local user_config = type(gs) == "function" and gs() or gs

---@type nvimpack-selector.Config
local config = vim.tbl_deep_extend("force", default_config, user_config)

return config
