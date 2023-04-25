local M = {}

function M.defaults()
  ---@class SessionConfig
  local defaults = {
    hooks = {
      pre = {
        save = function() end,
        delete = function() end,
        load = function() end,
      },
      post = {
        save = function() end,
        delete = function() end,
        load = function() end,
      },
    },
    ---@type string
    dir = vim.fn.stdpath "data" .. "/session",
  }
  return defaults
end

---@type SessionConfig
M.options = {}

function M.set(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults(), user_config or {})
end

return M
