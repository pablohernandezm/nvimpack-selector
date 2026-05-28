nvimpack-selector
=================

Work in progress — intentionally public.

What it is
---------

A tiny UI wrapper for Neovim's built-in package manager (vim.pack). 
It provides a small floating window to interact with packages. 
The plugin targets Neovim 0.12+ where `vim.pack` is available.

Usage
-----

- Install with your preferred plugin manager.
- In your config (optional) call:

Configuration
-------------

Call require('nvimpack-selector').setup(opts) to customise behaviour. 

Available options and defaults:

```lua
require('nvimpack-selector').setup({
  columns = {
    -- Per-column options. Each column is keyed by its identifier (name, rev, src).
    -- Fields:
    --  - title: string
    --  - width: integer
    --      positive: fixed width
    --      negative: fill remaining space (e.g. -1)
    --      0: hide the column
    --  - overflow: "ellipsis" | "cut" -- controls overflow display. You can set a custom string too.
    --  - priority: integer -- higher priority columns are placed earlier
    --  - value_formatter: fun(value: string): string -- custom column formatter
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
      width = -1, -- fill remaining space
      overflow = "ellipsis",
      priority = 1,
    },
  },

  window = {
    min_width = 50,
    min_height = 20,

    -- Title is an object with text and position ("left" | "center" | "right")
    title = {
      text = "Pack selector",
      position = "left",
    },

    -- Footer structure:
    --  entries: array of { "text", "HighlightGroup?" } entries
    --  separator: string used between entries
    --  position: "left" | "center" | "right"
    footer = {
      entries = {
        { "[u] update", "DiagnosticFloatingInfo" },
        { " " },
        { "[c] clear",  "DiagnosticFloatingHint" },
        { " " },
        { "[d] delete", "DiagnosticFloatingWarn" },
      },
      separator = " ",
      position = "left",
    },
  },
})
```

Commands
------

- `:NvimPackSelector open` — open the selector window

Status
------

This repository is very new and incomplete. Expect rough edges and frequent changes.
If you want to help or file issues, feel free to open one.

License
-------

This project is released under the terms in the LICENSE file.
