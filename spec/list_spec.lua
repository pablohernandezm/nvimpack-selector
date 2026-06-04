local list = require("nvimpack-selector.list")
local assert = require("luassert")
local stub = require("luassert.stub")

local buffer = 123
local max_width = 120
local sample_plugin = {
  active = true,
  path = "/some/path",
  rev = "abc1234",
  spec = { src = "github:user/repo", name = "user/repo" },
}

local sample_plugin2 = {
  active = true,
  path = "/other/path",
  rev = "def5678",
  spec = { src = "github:user/other", name = "user/other" },
}

local stubs = {}
require("nvimpack-selector").setup({
  columns = {
    name = {
      hl_group = "Conceal",
    },
    rev = {
      hl_group = "Cursor",
    },
    src = {
      hl_group = "DiffAdd",
    },
  },
})

local function setup_packs_stub(packs)
  if stubs.get_packs then
    stubs.get_packs:revert()
  end
  stubs.get_packs = stub(require("nvimpack-selector.pack"), "get", function()
    return packs
  end)
end

local function expect_no_lines_or_extmarks()
  assert.stub(stubs.nvim_buf_set_lines).called(0)
  assert.stub(stubs.nvim_buf_set_extmark).called(0)
end

before_each(function()
  stubs.nvim_buf_is_valid = stub(vim.api, "nvim_buf_is_valid", function()
    return true
  end)
  stubs.nvim_buf_get_lines = stub(vim.api, "nvim_buf_get_lines", function()
    return { "user/repo    abc1234    github:user/repo" }
  end)
  stubs.nvim_buf_set_lines = stub(vim.api, "nvim_buf_set_lines", function() end)
  stubs.nvim_buf_set_extmark = stub(vim.api, "nvim_buf_set_extmark", function() end)
  stubs.nvim_buf_del_extmark = stub(vim.api, "nvim_buf_del_extmark", function() end)
  stubs.nvim_get_namespaces = stub(vim.api, "nvim_get_namespaces", function()
    return {}
  end)
  stubs.nvim_create_namespace = stub(vim.api, "nvim_create_namespace", function()
    return 1
  end)

  -- Make vim.schedule synchronous, so the highlights are applied inmediately during tests
  stubs.schedule = stub(vim, "schedule", function(callback)
    callback()
  end)

  setup_packs_stub({})
end)

after_each(function()
  for _, s in pairs(stubs) do
    s:revert()
  end
  stubs = {}
end)

describe("display_list", function()
  it("validates inputs before proceeding", function()
    list.display_list(buffer, max_width)
    assert.stub(stubs.nvim_buf_is_valid).called_with(buffer)
  end)

  it("sets lines correctly when plugins exist", function()
    setup_packs_stub({
      sample_plugin,
    })

    list.display_list(buffer, max_width)
    assert.stub(stubs.nvim_buf_set_lines).called(1)
  end)

  it("does not create lines or extmarks when there are no plugins", function()
    list.display_list(buffer, max_width)
    expect_no_lines_or_extmarks()
  end)

  it("applies extmarks correctly when hl_group is set", function()
    setup_packs_stub({
      sample_plugin,
    })

    list.display_list(buffer, max_width)
    assert.stub(stubs.nvim_buf_set_extmark).called(3)  --- 3 highlight groups
    assert.stub(stubs.nvim_create_namespace).called(3) --- 3 columns, a namespace per column
  end)
end)

describe("selection list", function()
  it("populates items via display_list", function()
    setup_packs_stub({ sample_plugin, sample_plugin2 })
    list.display_list(buffer, max_width)

    local item1 = list.get(1)
    assert.are.same("user/repo", item1.name)
    assert.is_not_nil(item1.update)
    assert.is_not_nil(item1.remove)

    local item2 = list.get(2)
    assert.are.same("user/other", item2.name)
  end)

  it("get errors for out-of-range index", function()
    setup_packs_stub({ sample_plugin })
    list.display_list(buffer, max_width)

    assert.has_error(function()
      list.get(2)
    end)
  end)

  it("get returns nil after item is removed", function()
    setup_packs_stub({ sample_plugin })
    list.display_list(buffer, max_width)

    assert.is_not_nil(list.get(1))
    list.remove(1)
    assert.is_nil(list.get(1))
  end)

  it("find returns item by name", function()
    setup_packs_stub({ sample_plugin, sample_plugin2 })
    list.display_list(buffer, max_width)

    local result = list.find("user/other")
    assert.is_not_nil(result)

    ---@diagnostic disable-next-line
    assert.are.same(2, result[1])
    ---@diagnostic disable-next-line
    assert.are.same("user/other", result[2].name)
  end)

  it("find returns nil for unknown name", function()
    setup_packs_stub({ sample_plugin })
    list.display_list(buffer, max_width)

    assert.is_nil(list.find("does/not/exist"))
  end)

  it("find skips removed items", function()
    setup_packs_stub({ sample_plugin, sample_plugin2 })
    list.display_list(buffer, max_width)

    list.remove(2)
    assert.is_nil(list.find("user/other"))

    local result = list.find("user/repo")
    assert.is_not_nil(result)

    ---@diagnostic disable-next-line
    assert.are.same(1, result[1])
    ---@diagnostic disable-next-line
    assert.are.same("user/repo", result[2].name)
  end)

  it("remove highlights removed plugin line", function()
    setup_packs_stub({ sample_plugin })
    list.display_list(buffer, max_width)

    list.remove(1)
    assert.stub(stubs.nvim_create_namespace).was_called_with("nvimpack-selector.list.removed")
    assert.is_nil(list.get(1))
  end)

  it("remove deletes extmarks", function()
    setup_packs_stub({ sample_plugin })
    list.display_list(buffer, max_width)

    list.remove(1)
    assert.stub(stubs.nvim_buf_del_extmark).called(3)
  end)

  it("update removes item when plugin data is gone", function()
    setup_packs_stub({ sample_plugin })
    list.display_list(buffer, max_width)

    setup_packs_stub({})
    list.update(1)

    assert.is_nil(list.get(1))
  end)

  it("remove keeps line content and nils slot for multiple items", function()
    setup_packs_stub({ sample_plugin, sample_plugin2 })
    list.display_list(buffer, max_width)

    list.remove(1)
    list.remove(2)

    assert.is_nil(list.get(1))
    assert.is_nil(list.get(2))
  end)

  it("remove is a no-op for already removed slot", function()
    setup_packs_stub({ sample_plugin })
    list.display_list(buffer, max_width)

    list.remove(1)
    assert.is_nil(list.get(1))
    list.remove(1)
    assert.is_nil(list.get(1))
  end)
end)
