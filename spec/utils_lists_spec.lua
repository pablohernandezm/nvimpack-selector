local assert = require("luassert")
local lists = require("nvimpack-selector.utils.lists")

describe("utils.lists", function()
  describe("intersperse", function()
    it("returns an empty table when given an empty list", function()
      assert.are.same({}, lists.intersperse({}, 0))
    end)

    it("inserts the element between list items", function()
      assert.are.same({ 1, 0, 2, 0, 3 }, lists.intersperse({ 1, 2, 3 }, 0))
      assert.are.same({ 1, 0, 2, 0, 3 }, lists.intersperse({ 1, 2, 3 }, function(item, _)
        return 0
      end))

      assert.are.same({ "a", "-", "b" }, lists.intersperse({ "a", "b" }, "-"))
      assert.are.same({ "a", { "-" }, "b" }, lists.intersperse({ "a", "b" }, { "-" }))
      assert.are.same({ "a", { item = "-" }, "b" }, lists.intersperse({ "a", "b" }, { item = "-" }))
    end)
  end)

  describe("surround", function()
    it("adds start and end elements around the list", function()
      assert.are.same({ "<", "a", "b", ">" }, lists.surround({ "a", "b" }, "<", ">"))
      assert.are.same({ { "<" }, "a", "b", { ">" } }, lists.surround({ "a", "b" }, { "<" }, { ">" }))
      assert.are.same(
        { { it = "<" }, "a", "b", { it = ">" } },
        lists.surround({ "a", "b" }, { it = "<" }, { it = ">" })
      )
    end)

    it("handles a nil start element", function()
      assert.are.same({ "a", "b", ">" }, lists.surround({ "a", "b" }, nil, ">"))
    end)

    it("handles a nil end element", function()
      assert.are.same({ "<", "a", "b" }, lists.surround({ "a", "b" }, "<", nil))
    end)

    it("returns a list with the same contents when both surrounds are nil", function()
      assert.are.same({ 1, 2 }, lists.surround({ 1, 2 }, nil, nil))
    end)
  end)
end)
