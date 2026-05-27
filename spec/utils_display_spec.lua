local assert = require("luassert")

describe("utils.display", function()
  local plugin = require("nvimpack-selector")
  local disutils = require("nvimpack-selector.utils.display")

  describe("available_win_width", function()
    local columns = vim.deepcopy(plugin.getConf()).columns
    local max = 100

    local keys = vim.tbl_keys(columns)

    local per_col = math.floor(max / #keys)

    before_each(function()
      local available = max

      for _, k in ipairs(keys) do
        if k ~= "rev" then
          columns[k].width = per_col
          available = available - per_col
        end
      end

      columns.rev.width = available
    end)

    it("negative counter should be 0 if there is no columns with negative width", function()
      local _, neg_ctr = disutils.available_win_width(columns, max)
      assert.are_equal(0, neg_ctr)
    end)

    it("available width should be 0 if the columns use all the width", function()
      local av, _ = disutils.available_win_width(columns, max)
      assert.are_equal(0, av)
    end)

    it("negative counter should be greater than 0 if there are columns with negative width", function()
      ---@param expected integer
      local function t(expected)
        local _, neg_ctr = disutils.available_win_width(columns, max)
        assert.are_equal(expected, neg_ctr)
      end

      columns.name.width = -1
      t(1)

      columns.rev.width = -1
      t(2)

      columns.src.width = -1
      t(3)

      columns.src.width = 0
      t(2)
    end)

    it("The available width must be greater than 0 if the columns do not use the full width.", function()
      ---@param expected integer
      local function t(expected)
        local av, _ = disutils.available_win_width(columns, max)
        assert.are_equal(expected, av)
      end

      local name_ow = columns.name.width
      columns.name.width = 0
      t(name_ow)

      local rev_ow = columns.rev.width
      columns.rev.width = 0
      t(name_ow + rev_ow)

      columns.name.width = -1
      columns.rev.width = -1
      t(name_ow + rev_ow)

      columns.name.width = name_ow
      t(rev_ow)
    end)
  end)
end)
