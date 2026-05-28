--- == COLUMN CONFIG == ---
---@class (partial) nvimpack-selector.Opts.Columns.Opts: nvimpack-selector.Config.Columns.Opts

---@class nvimpack-selector.Opts.Columns
---@field name? nvimpack-selector.Opts.Columns.Opts
---@field rev?  nvimpack-selector.Opts.Columns.Opts
---@field src?  nvimpack-selector.Opts.Columns.Opts

--- == WINDOW  CONFIG == ---
---@class (partial) nvimpack-selector.Opts.Window.Title: nvimpack-selector.Config.Window.Title
---@class (partial) nvimpack-selector.Opts.Window.Footer: nvimpack-selector.Config.Window.Footer

---@class (partial)nvimpack-selector.Opts.Window: nvimpack-selector.Config.Window
---@field title? nvimpack-selector.Opts.Window.Title
---@field footer? nvimpack-selector.Opts.Window.Footer

--- == USER CONFIGURATION == ---
---@class nvimpack-selector.Opts
---@field columns? nvimpack-selector.Opts.Columns
---@field window? nvimpack-selector.Opts.Window

---@type nvimpack-selector.Opts | fun(): nvimpack-selector.Opts | nil
vim.g.nvimpack_selector = vim.g.nvimpack_selector
