local M = {}

function M.list()
  local config = require("session.config")

  local files = {}
  for file in vim.fs.dir(config.options.dir) do
    table.insert(files, file)
  end
end

return M
