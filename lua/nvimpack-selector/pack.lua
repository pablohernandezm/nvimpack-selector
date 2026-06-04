local pack = vim.pack
local M = {}

M.get = pack.get

---Update the plugin at the cursor and refresh its list entry.
M.updateSelected = function()
  local selected, index = require("nvimpack-selector").getSelected()

  if selected and index then
    pack.update({ selected.name }, { force = true })

    require("nvimpack-selector.list").update(index)
  end
end

M.update = pack.update

---Delete all inactive plugins and remove them from the list.
M.clear = function()
  local plugins = pack.get()

  ---@type string[]
  local not_loaded = {}

  for i = 1, #plugins do
    local plugin = plugins[i]
    if not plugin.active then
      table.insert(not_loaded, plugin.spec.name)
    end
  end

  pack.del(not_loaded)

  for _, name in ipairs(not_loaded) do
    local found = require("nvimpack-selector.list").find(name)

    if found then
      require("nvimpack-selector.list").remove(found[1])
    end
  end
end

return M
