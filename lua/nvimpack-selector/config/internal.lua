--- == COLUMN CONFIG == ---
---@class nvimpack-selector.Config.Columns.Opts
---@field title string
---@field width integer
---@field overflow "ellipsis" | "cut" | string
---@field priority integer

---@class nvimpack-selector.Config.Columns
---@field name nvimpack-selector.Config.Columns.Opts
---@field rev  nvimpack-selector.Config.Columns.Opts
---@field src  nvimpack-selector.Config.Columns.Opts

--- == WINDOW  CONFIG == ---
---@alias nvimpack-selector.Config.Window.Position ("left" | "center" | "right")

---@class nvimpack-selector.Config.Window.Title
---@field text string
---@field position nvimpack-selector.Config.Window.Position

---@class nvimpack-selector.Config.Window.Footer
---@field entries {[1]: string, [2]: string?}[]
---@field separator string
---@field position nvimpack-selector.Config.Window.Position

---@class nvimpack-selector.Config.Window
---@field min_width  integer
---@field min_height integer
---@field title nvimpack-selector.Config.Window.Title
---@field footer nvimpack-selector.Config.Window.Footer

--- == DEFAULT CONFIGURATION == ---
---@class nvimpack-selector.Config
---@field columns nvimpack-selector.Config.Columns
---@field window nvimpack-selector.Config.Window
local default_config = {
  columns = {
    name = {
      title = "name",
      width = 20,
      overflow = "ellipsis",
      priority = 1,
    },
    rev = {
      title = "rev",
      width = 7,
      overflow = "cut",
      priority = 2,
    },
    src = {
      title = "src",
      width = -1,
      overflow = "ellipsis",
      priority = 3,
    },
  },

  window = {
    min_width = 50,
    min_height = 20,
    title = {
      text = "Pack selector",
      position = "left",
    },
    footer = {
      entries = {
        { "[u] update", "DiagnosticFloatingInfo" },
        { "[c] clear", "DiagnosticFloatingHint" },
        { "[d] delete", "DiagnosticFloatingWarn" },
      },
      separator = " ",
      position = "left",
    },
  },
}

local gs = vim.g.nvimpack_selector or {}
local user_config = type(gs) == "function" and gs() or gs

---@type nvimpack-selector.Config
local config = vim.tbl_deep_extend("force", default_config, user_config)

return config
