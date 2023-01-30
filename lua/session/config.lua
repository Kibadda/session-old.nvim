local M = {}

function M.defaults()
  ---@class SessionConfig
  local defaults = {
    ---@type function?
    pre_save_hook = nil,
    dir = vim.fn.stdpath "data" .. "/session",
    -- log = vim.fn.stdpath "state" .. "/session.log",
    log = nil,
  }
  return defaults
end

---@type SessionConfig
M.options = {}

function M.set(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults(), user_config or {})
end

return M
