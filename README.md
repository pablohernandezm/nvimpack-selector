nvimpack-selector
=================

Work in progress — intentionally public.

What it is
---------

A tiny UI wrapper for Neovim's built-in package facilities (vim.pack). It provides
a small floating window to interact with packages. The plugin targets Neovim 0.12+
where `vim.pack` is available.

Usage
-----

- Install with your preferred plugin manager.
- In your config (optional) call:

```lua
require('nvimpack-selector').setup({
  -- optional settings, the plugin has sensible defaults
  ui = {
    w = 50,
    h = 20,
    title = "Pack selector",
    -- footer is an array of entries shown on the floating window footer
  }
})
```

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
