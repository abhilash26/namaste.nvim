-- dashboard-nvim inspired theme for namaste.nvim
-- Based on alpha-nvim's dashboard theme

local M = {}

-- Dashboard-style header with hyper logo
M.header = function()
  return {
    [[                                                                       ]],
    [[                                                                       ]],
    [[                                                                       ]],
    [[                                                                       ]],
    [[                                                                     ]],
    [[       ████ ██████           █████      ██                     ]],
    [[      ███████████             █████                             ]],
    [[      █████████ ███████████████████ ███   ███████████   ]],
    [[     █████████  ███    █████████████ █████ ██████████████   ]],
    [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
    [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
    [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    [[                                                                       ]],
    [[                                                                       ]],
    [[                                                                       ]],
  }
end

-- Dashboard-style footer with inspirational message
M.footer = function()
  local version = vim.version()
  local utils = require("namaste.utils")
  local project = utils.get_project_name()

  return string.format(
    "✨ Neovim v%d.%d.%d | 🚀 %s",
    version.major,
    version.minor,
    version.patch,
    project
  )
end

-- Dashboard theme configuration
function M.config()
  local utils = require("namaste.utils")
  local finder = utils.detect_finder()
  local pm = utils.detect_package_manager()
  local finder_cmds = utils.get_finder_commands(finder)

  return {
    header = M.header,
    footer = M.footer,

    -- Dashboard shows fewer MRU files
    show_mru = true,
    mru_limit = 5,

    -- Sessions are optional in dashboard
    show_sessions = false,
    session_limit = 3,

    -- Dashboard has more spacious layout
    spacing = {
      header_padding = 2,
      section_padding = 1,
      footer_padding = 2,
      quote_padding = 2,
      mru_padding = 1,
      sessions_padding = 1,
    },

    -- Enable quotes for inspiration
    quote = {
      enabled = true,
      position = "below_sections", -- "above_sections" or "below_sections"
    },

    -- Dashboard-style sections with icons
    sections = {
      {
        key = "f",
        desc = "Find File",
        action = finder_cmds.find_files,
        icon = "󰈞 ",
      },
      {
        key = "n",
        desc = "New File",
        action = function()
          vim.cmd("enew")
        end,
        icon = "󰈔 ",
      },
      {
        key = "r",
        desc = "Recent Files",
        action = finder_cmds.oldfiles,
        icon = "󰄉 ",
      },
      {
        key = "g",
        desc = "Find Text",
        action = finder_cmds.live_grep,
        icon = "󰊄 ",
      },
      {
        key = "c",
        desc = "Configuration",
        action = function()
          vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
        end,
        icon = " ",
      },
      {
        key = "s",
        desc = "Restore Session",
        action = function()
          local session_cmd = utils.get_session_restore_command()
          if session_cmd then
            vim.cmd(session_cmd)
          else
            vim.notify("No session manager detected", vim.log.levels.WARN)
          end
        end,
        icon = "󰦛 ",
      },
      {
        key = "l",
        desc = "Lazy",
        action = function()
          if pm == "lazy" then
            vim.cmd("Lazy")
          else
            vim.notify("lazy.nvim not detected", vim.log.levels.WARN)
          end
        end,
        icon = "💤 ",
      },
      {
        key = "q",
        desc = "Quit",
        action = function()
          vim.cmd("quit")
        end,
        icon = "󰩈 ",
      },
    },
  }
end

return M

