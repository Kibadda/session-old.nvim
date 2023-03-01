describe("config", function()
  it("has default values after set()", function()
    local config = require "session.config"

    config.set()

    assert.equal(vim.fn.stdpath "data" .. "/session", config.options.dir)
  end)

  it("has new values with custom config", function()
    local config = require "session.config"

    local dir = "~/other/session/location"

    config.set {
      dir = dir,
    }

    assert.equal(dir, config.options.dir)
  end)
end)
