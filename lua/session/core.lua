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

function M.load(session)
  session = check(session)
  if session then
    M.update()
    vim.cmd.bufdo {
      args = { "bd" },
      bang = true,
    }
    vim.cmd.source(session)
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
        os.remove(session)
      end
    end)
  end
end

function M.new()
  local session
  vim.ui.input({ prompt = "Session name: "}, function(input)
    if input then
      session = input
    end
  end)

  if check(session) == nil then
    if M.hooks.pre then
      M.hooks.pre()
    end
    vim.cmd.mksession {
      args = { ("%s/%s"):format(require("session.config").options.dir, session) },
    }
  end
end

function M.update(session)
  if session then
    session = check(session)
  else
    session = current()
  end

  if session then
    local config = require "session.config"
    if type(config.options.pre_save_hook) == "function" then
      config.options.pre_save_hook()
    end
    vim.cmd.mksession {
      args = { session },
      bang = true,
    }
  end
end

return M
