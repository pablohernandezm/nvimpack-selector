local assert = require("luassert")
local columns = require("nvimpack-selector.utils.columns")

describe("utils.columns", function()
  ---@type nvimpack-selector.Config
  local conf = nil

  local settings = {
    columns = {
      name = {
        priority = 2,
        overflow = "ellipsis",
        width = 10,
      },
      rev = {
        priority = 3,
        overflow = "cut",
        width = 7,
      },
      src = {
        priority = 1,
        overflow = "---",
        width = 6,
      },
    },
  }

  local filler = "x"

  setup(function()
    local plugin = require("nvimpack-selector")
    plugin.setup(settings)

    conf = plugin.getConf()
  end)

  describe("sort_columns", function()
    ---@type nvimpack-selector.Config.Column[]
    local sorted = nil

    setup(function()
      sorted = columns.sort_columns(conf.columns)
    end)

    it("should be sorted", function()
      assert.are_same(sorted[1], { "rev", conf.columns.rev })
      assert.are_same(sorted[2], { "name", conf.columns.name })
      assert.are_same(sorted[3], { "src", conf.columns.src })
    end)
  end)

  describe("format_column", function()
    it("should return nothing when the column width is 0", function()
      local name = vim.deepcopy(conf.columns.name)
      name.width = 0

      local result = columns.format_column(filler:rep(10), name)

      assert.are_equal("", result)
    end)

    it("should respect left alignment", function()
      local free_space = 3
      local rev = conf.columns.rev

      local result = columns.format_column(filler:rep(rev.width - free_space), rev)

      assert.are_equal(filler:rep(rev.width - free_space) .. (" "):rep(free_space), result)
    end)

    it("should apply overflow `ellipsis`", function()
      local name = vim.deepcopy(conf.columns.name)
      name.overflow = "ellipsis"

      local result = columns.format_column(filler:rep(name.width + 1), name)

      assert.are_equal(filler:rep(name.width - 3) .. "...", result)
    end)

    it("should apply overflow `cut`", function()
      local rev = vim.deepcopy(conf.columns.rev)
      rev.overflow = "cut"

      local result = columns.format_column(filler:rep(rev.width + 1), rev)

      assert.are_equal(filler:rep(rev.width), result)
    end)

    it("should apply custom overflow text", function()
      local src = vim.deepcopy(conf.columns.src)
      src.overflow = "---"

      local result = columns.format_column(filler:rep(src.width + 1), src)

      assert.are_equal(filler:rep(src.width - src.overflow:len()) .. src.overflow, result)
    end)

    it("should not apply overflow", function()
      local name = vim.deepcopy(conf.columns.name)
      name.width = 30
      name.overflow = "ellipsis"

      local result = columns.format_column(filler:rep(name.width), name)

      assert.are_equal(filler:rep(name.width), result)
      assert.are_not_equal(result:sub(name.width - 3, -1), "...")

      local free = 10
      result = columns.format_column(filler:rep(name.width - free), name)
      assert.are_equal(filler:rep(name.width - free) .. (" "):rep(free), result)
    end)

    it("should apply value_formatter", function()
      local name = vim.deepcopy(conf.columns.name)
      name.width = 20
      local format = "* %s *"
      local formatted = format:format(filler)

      name.value_formatter = function(value)
        return ("* %s *"):format(value)
      end

      local result = columns.format_column(filler, name)
      assert.are_equal(formatted .. (" "):rep(name.width - formatted:len()), result)
    end)

    it("should throw error on invalid value_formatter", function()
      local name = vim.deepcopy(conf.columns.name)
      name.value_formatter = function(_)
        ---@diagnostic disable-next-line
        return nil
      end

      assert.has_error(function()
        columns.format_column(filler, name)
      end)
    end)
  end)

  describe("apply_column_settings", function()
    ---@type vim.pack.PlugData
    local data = {
      active = true,
      path = "/some/path",
      rev = "abc1234",
      spec = { src = "github:user/repo", name = "user/repo", version = nil, data = {} },
    }

    it("should return a valid array", function()
      local result = columns.apply_column_settings(data, settings.columns)

      assert.are_same({
        columns.format_column(data.rev, conf.columns.rev),
        columns.format_column(data.spec.name, conf.columns.name),
        columns.format_column(data.spec.src, conf.columns.src),
      }, result)
    end)

    it("should throw error when plug data is nil", function()
      assert.has_error(function()
        ---@diagnostic disable-next-line
        columns.apply_column_settings(nil, settings.columns)
      end)
    end)

    it("should return an empty list when opts is nil", function()
      assert.are_same(
        {},
        ---@diagnostic disable-next-line
        columns.apply_column_settings(data, nil)
      )
    end)
  end)
end)
