---@alias nvimpack-selector.Config.Window.Position ("left" | "center" | "right")
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
    title = {
      ---@type string
      text = "Pack selector",
      ---@type nvimpack-selector.Config.Window.Position
      position = "left",
    },
    footer = {
      --- Array of entries to be shown on the floating window footer.
      --- By default it shows some window keymaps.
      ---@type ({ [1]: string, [2]: string? })[]
      entries = {
        { "[u] update", "DiagnosticFloatingInfo" },
        { "[c] clear", "DiagnosticFloatingHint" },
        { "[d] delete", "DiagnosticFloatingWarn" },
      },
      ---@type string
      separator = " ",
      ---@type nvimpack-selector.Config.Window.Position
      position = "left",
    },
  },
}

local gs = vim.g.nvimpack_selector or {}
local user_config = type(gs) == "function" and gs() or gs

---@type nvimpack-selector.Config
local config = vim.tbl_deep_extend("force", default_config, user_config)

return config
