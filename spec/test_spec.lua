local assert = require("luassert")

---@type nvimpack-selector.Opts
local settings = {
  window = {
    title = "Testing",
  }
}

describe("Plugin settings", function()
  ---@module "nvimpack-selector"
  local plugin = nil

  setup(function()
    plugin = require("nvimpack-selector")

    plugin.setup(settings)
  end)

  describe("Open results", function()
    ---@type nvimpack-selector.Config
    local results = nil

    setup(function()
      results = plugin.open_float()
    end)

    it("Should apply configuration", function()
      assert.are.Equal(settings.window.title, results.window.title)
    end)
  end)
end)
