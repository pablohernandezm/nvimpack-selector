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

local stubs = {}
require("nvimpack-selector").setup({
  columns = {
    name = {
      hl_group = "Conceal"
    },
    rev = {
      hl_group = "Cursor"
    },
    src = {
      hl_group = "DiffAdd"
    }
  }
})

local function setup_packs_stub(packs)
  if stubs.get_packs then stubs.get_packs:revert() end
  stubs.get_packs = stub(require("nvimpack-selector.pack"), "get", function() return packs end)
end

local function expect_no_lines_or_extmarks()
  assert.stub(stubs.nvim_buf_set_lines).called(0)
  assert.stub(stubs.nvim_buf_set_extmark).called(0)
end

before_each(function()
  stubs.nvim_buf_is_valid     = stub(vim.api, "nvim_buf_is_valid", function() return true end)
  stubs.nvim_buf_set_lines    = stub(vim.api, "nvim_buf_set_lines", function() end)
  stubs.nvim_buf_set_extmark  = stub(vim.api, "nvim_buf_set_extmark", function() end)
  stubs.nvim_get_namespaces   = stub(vim.api, "nvim_get_namespaces", function() return {} end)
  stubs.nvim_create_namespace = stub(vim.api, "nvim_create_namespace", function() return 1 end)

  -- Make vim.schedule synchronous, so the highlights are applied inmediately during tests
  stubs.schedule              = stub(vim, "schedule", function(callback) callback() end)

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
      sample_plugin
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
      sample_plugin
    })

    list.display_list(buffer, max_width)
    assert.stub(stubs.nvim_buf_set_extmark).called(3)  --- 3 highlight groups
    assert.stub(stubs.nvim_create_namespace).called(3) --- 3 columns, a namespace per column
  end)
end)

