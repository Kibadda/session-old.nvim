local M = {}

---@param user_config? SessionConfig
function M.setup(user_config)
  require("session.config").set(user_config)
end

return M
