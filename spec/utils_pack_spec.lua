local assert = require("luassert")

describe("nvimpack-selector.utils.pack", function()
  local pack = require("nvimpack-selector.utils.pack")

  ---@type vim.pack.PlugData
  local sample = {
    active = true,
    path = "/some/path",
    rev = "abc1234",
    spec = { src = "github:user/repo", name = "user/repo", version = nil, data = {} },
  }

  it("extracts the name property", function()
    local v = pack.extract_property("name", sample)
    assert.are.equal(sample.spec.name, v)
  end)

  it("extracts the src property", function()
    local v = pack.extract_property("src", sample)
    assert.are.equal(sample.spec.src, v)
  end)

  it("extracts the rev property", function()
    local v = pack.extract_property("rev", sample)
    assert.are.equal(sample.rev, v)
  end)

  it("returns nil for unknown properties", function()
    ---@diagnostic disable-next-line
    local v = pack.extract_property("unknown", sample)

    assert.is_nil(v)
  end)

  it("returns nil for nil parameters", function()
    ---@diagnostic disable-next-line
    local v = pack.extract_property(nil, sample)
    assert.is_nil(v)

    ---@diagnostic disable-next-line
    v = pack.extract_property(sample.rev, nil)
    assert.is_nil(v)

    ---@diagnostic disable-next-line
    v = pack.extract_property(nil, nil)
    assert.is_nil(v)
  end)
end)
