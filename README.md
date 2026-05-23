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
  ui = {
    -- Minimum window width (integer)
    min_width = 50,

    -- Minimum window height (integer)
    min_height = 20,

    -- Window title (string)
    title = "Pack selector",

    -- Footer is an array of entries shown on the floating window footer.
    -- Each entry may be:
    --  - a plain string, e.g. { " " }
    --  - an array: { "text", "HighlightGroup" }
    footer = {
      { "[u] update", "DiagnosticFloatingInfo" },
      { " " },
      { "[c] clear",  "DiagnosticFloatingHint" },
      { " " },
      { "[d] delete", "DiagnosticFloatingWarn" },
    },
  },

  columns = {
    -- Which columns to display and in what order. Valid identifiers: "name", "rev", "src"
    order = { "name", "rev", "src" },

    -- How to display each column (corresponds to `order`).
    -- Each entry can be:
    --  - an integer: fixed width, e.g. 20
    --  - a negative integer (e.g. -1): fill remaining space
    --  - 0: hide the column
    --  - an array: { width, "ellipsis" | "cut" } where the second element controls overflow display
    -- Default:
    display = { 20, { 7, "cut" }, -1 },
  }
})
```

Quick examples

- Change only the window title:

```lua
require('nvimpack-selector').setup({ ui = { title = "My Packs" } })
```

- Hide the "src" column:

```lua
require('nvimpack-selector').setup({
  columns = { order = { "name", "rev", "src" }, display = { 30, 10, 0 } }
})
```

  Or just remove the column from the order entries:

```lua
require('nvimpack-selector').setup({
  columns = { order = { "name", "rev"}}
})
```

- Let the first column expand to use remaining space:

```lua
require('nvimpack-selector').setup({
  columns = { order = { "name", "rev" }, display = { -1, 10 } }
})
```

- Reserve 30 characters and show ellipsis on overflow for the `name` column:

```lua
require('nvimpack-selector').setup({
  columns = { order = { "name", "rev" }, display = { {30, "ellipsis"}, 10 } }
})
```

Notes

- Because setup merges with defaults, you only need to include the parts you want to change.

- Commands:

- `:NvimPackSelector open` — open the selector window
- `:NvimPackSelector toggle` — toggle the selector window

Status
------

This repository is very new and incomplete. Expect rough edges and frequent changes.
If you want to help or file issues, feel free to open one.

License
-------

This project is released under the terms in the LICENSE file.
