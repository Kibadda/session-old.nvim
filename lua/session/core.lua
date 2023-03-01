local M = {}

local function current()
  return #vim.v.this_session > 0 and vim.v.this_session or nil
end

local function check(session)
  local find = vim.fs.find(session or "", {
    path = require("session.config").options.dir,
  })

  if #find == 0 then
    return nil
  end

  return find[1]
end

---@param action string
---@param callback function
local function hooks(action, callback)
  local config = require "session.config"

  if type(config.options.hooks.pre[action]) == "function" then
    config.options.hooks.pre[action]()
  end

  callback()

  if type(config.options.hooks.post[action]) == "function" then
    config.options.hooks.post[action]()
  end
end

function M.load(session)
  session = check(session)
  if session then
    M.update()
    hooks("load", function()
      vim.cmd.bufdo {
        args = { "bwipeout" },
        bang = true,
      }
      vim.cmd.source(session)
    end)
  end
end

function M.delete(session)
  if session then
    session = check(session)
  else
    session = current()
  end

  if session then
    vim.ui.select({ "Yes", "No" }, { prompt = ("Delete session %s"):format(session) }, function(choice)
      if choice == "Yes" then
        hooks("delete", function()
          os.remove(session)
        end)
      end
    end)
  end
end

function M.new()
  local session
  vim.ui.input({ prompt = "Session name: " }, function(input)
    if input then
      session = input
    end
  end)

  if session and check(session) == nil then
    hooks("save", function()
      vim.cmd.mksession {
        args = { ("%s/%s"):format(require("session.config").options.dir, session) },
      }
    end)
  end
end

function M.update(session)
  if session then
    session = check(session)
  else
    session = current()
  end

  if session then
    hooks("save", function()
      vim.cmd.mksession {
        args = { session },
        bang = true,
      }
    end)
  end
end

return M
