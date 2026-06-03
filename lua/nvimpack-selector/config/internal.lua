--- == COLUMN CONFIG == ---

---@class nvimpack-selector.Config.Columns.Opts
---@field title string
---@field width integer
---@field overflow "ellipsis" | "cut" | string
---@field priority integer
---@field value_formatter? fun(value: string):string Custom column value formatter.
---@field hl_group? string

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

--- == KEYMAP CONFIG == ---
---@alias nvimpack-selector.KeymapHandler fun()

--- == DEFAULT CONFIGURATION == ---

---@class nvimpack-selector.Config
---@field columns nvimpack-selector.Config.Columns
---@field window nvimpack-selector.Config.Window
---@field keymaps table<string, nvimpack-selector.KeymapHandler>
local default_config = {
  ---@enum (key) nvimpack-selector.Config.Column
  columns = {
    name = {
      title = "name",
      width = 20,
      overflow = "ellipsis",
      priority = 3,
    },
    rev = {
      title = "rev",
      width = 10,
      overflow = "cut",
      priority = 2,
      value_formatter = function(value)
        return value:sub(1, 7)
      end,
    },
    src = {
      title = "src",
      width = -1,
      overflow = "ellipsis",
      priority = 1,
      hl_group = "Directory",
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
        { "[u] update", "FloatFooter" },
        { "[U] update all", "FloatFooter" },
        { "[c] clear", "FloatFooter" },
      },
      separator = " ",
      position = "left",
    },
  },

  keymaps = {
    ["U"] = require("nvimpack-selector.pack").update,
    ["u"] = require("nvimpack-selector.pack").updateSelected,
    ["c"] = require("nvimpack-selector.pack").clear,
  },
}

local gs = vim.g.nvimpack_selector or {}
local user_config = type(gs) == "function" and gs() or gs

---@type nvimpack-selector.Config
local config = vim.tbl_deep_extend("force", default_config, user_config)

return config
