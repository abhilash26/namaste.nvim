-- vim-startify inspired theme for namaste.nvim
-- Based on alpha-nvim's startify theme

local M = {}

-- Startify-style header with simple ASCII art
M.header = function()
  return {
    [[                                   ]],
    [[                                   ]],
    [[                                   ]],
    [[   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ]],
    [[    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ]],
    [[          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ]],
    [[           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ]],
    [[          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ]],
    [[   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷ ]],
    [[  ⣔⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟ ]],
    [[ ⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇  ]],
    [[ ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇  ]],
    [[ ⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿   ]],
    [[  ⠈⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠇    ]],
    [[                                   ]],
    [[                                   ]],
    [[                                   ]],
  }
end

-- Startify-style footer
M.footer = function()
  local version = vim.version()
  local stats = vim.api.nvim_list_uis()[1]
  local utils = require("namaste.utils")
  local project = utils.get_project_name()

  return string.format(
    "Neovim v%d.%d.%d | %dx%d | %s",
    version.major,
    version.minor,
    version.patch,
    stats.width,
    stats.height,
    project
  )
end

-- Startify theme configuration
function M.config()
  return {
    header = M.header,
    footer = M.footer,

    -- Startify shows MRU by default
    show_mru = true,
    mru_limit = 10,

    -- Startify shows sessions prominently
    show_sessions = true,
    session_limit = 5,

    -- Startify has compact spacing
    spacing = {
      header_padding = 1,
      section_padding = 0,
      footer_padding = 1,
      quote_padding = 1,
      mru_padding = 1,
      sessions_padding = 1,
    },

    -- No quotes in startify style
    quote = {
      enabled = false,
    },

    -- Minimal sections (startify focuses on MRU/sessions)
    sections = {
      {
        key = "e",
        desc = "New File",
        action = function()
          vim.cmd("enew")
        end,
        icon = "󰈔 ",
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

