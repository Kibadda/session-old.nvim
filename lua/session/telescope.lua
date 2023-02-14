local M = {}

function M.list(opts)
  local config = require "session.config"

  local files = {}
  for file in vim.fs.dir(config.options.dir) do
    table.insert(files, file)
  end

  require("telescope.pickers")
    .new(
      opts or {},
      require("telescope.themes").get_dropdown {
        prompt_title = "Sessions",
        finder = require("telescope.finders").new_table {
          results = files,
        },
        sorter = require("telescope.config").values.generic_sorter(opts),
        mappings = {
          i = {
            -- BUG: why this no work
            ["<C-l>"] = false,
          },
        },
        attach_mappings = function(prompt_bufnr, map)
          local actions = require "telescope.actions"
          local action_state = require "telescope.actions.state"

          local function run(action)
            return function()
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              require("session.core")[action](entry[1])
            end
          end

          actions.select_default:replace(run "load")

          map("n", "d", run "delete")
          map("n", "u", run "update")
          map("n", "l", run "load")

          map("i", "<C-d>", run "delete")
          map("i", "<C-u>", run "update")
          map("i", "<C-l", run "load")

          return true
        end,
      }
    )
    :find()
end

return M
