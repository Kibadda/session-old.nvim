local M = {}

---@param user_config? SessionConfig
function M.setup(user_config)
  local config = require("session.config")
  config.set(user_config)

  if vim.fn.isdirectory(config.options.dir) == 0 then
    vim.fn.mkdir(config.options.dir, "p")
  end
end

return M
