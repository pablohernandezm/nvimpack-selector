local assert = require("luassert")

---@type nvimpack-selector.Opts
local settings = {
  window = {
    title = {
      text = "Testing",
    },
  },
}

describe("settings", function()
  ---@module "nvimpack-selector"
  local plugin = nil

  setup(function()
    plugin = require("nvimpack-selector")

    plugin.setup(settings)
  end)

  it("should apply configuration", function()
    assert.are.Equal(settings.window.title.text, plugin.getConf().window.title.text)
  end)

  describe("floating window", function()
    ---@type integer
    local buffer = nil

    ---@type integer
    local window = nil

    setup(function()
      buffer, window = plugin.open_float()
    end)

    it("Should return a valid buffer", function()
      assert.is_true(vim.api.nvim_buf_is_valid(buffer))
    end)

    it("Should return a valid window", function()
      assert.is_true(vim.api.nvim_win_is_valid(window))
    end)
  end)
end)
