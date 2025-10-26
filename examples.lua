-- Example configuration for namaste.nvim
-- Copy this to your init.lua or lazy.nvim config

return {
  -- Basic setup with defaults
  basic = function()
    require("namaste").setup()
  end,

  -- Auto-open on startup
  auto_open = function()
    require("namaste").setup({
      auto_open = true,
    })
  end,

  -- Minimal setup
  minimal = function()
    require("namaste").setup({
      header = "Welcome to Neovim!",
      sections = {
        { key = "f", desc = "Find File", action = ":Telescope find_files<CR>" },
        { key = "r", desc = "Recent", action = ":Telescope oldfiles<CR>" },
        { key = "q", desc = "Quit", action = ":qa<CR>" },
      },
      footer = "",
    })
  end,

  -- With dynamic greeting
  dynamic_greeting = function()
    require("namaste").setup({
      header = function()
        local hour = tonumber(os.date("%H"))
        local greeting = hour < 12 and "Good Morning"
                      or hour < 18 and "Good Afternoon"
                      or "Good Evening"
        local user = os.getenv("USER") or "user"
        return {
          "",
          "  ╔═══════════════════════════════════════╗",
          "  ║                                       ║",
          "  ║   " .. greeting .. ", " .. user .. "!" .. string.rep(" ", 28 - #greeting - #user) .. "║",
          "  ║                                       ║",
          "  ╚═══════════════════════════════════════╝",
          "",
        }
      end,
    })
  end,

  -- With custom ASCII art
  custom_art = function()
    require("namaste").setup({
      header = {
        "                                   ",
        "                                   ",
        "    ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿ ",
        "  ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣿ ",
        "  ⣾⣿⡿⡁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⡟⢸ ",
        " ⢠⣿⠏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⡿⠃⠄⠹ ",
        " ⣾⠋⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢻⣿⣿⣿⡟⠁⠄⠄⠄ ",
        "                                   ",
        "        Doge Approves This Setup   ",
        "                                   ",
      },
    })
  end,

  -- With Lazy.nvim stats
  lazy_stats = function()
    require("namaste").setup({
      footer = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return string.format(
          "⚡ Loaded %d/%d plugins in %dms",
          stats.loaded,
          stats.count,
          ms
        )
      end,
    })
  end,

  -- Complete custom setup
  complete = function()
    require("namaste").setup({
      auto_open = true,

      header = function()
        local hour = tonumber(os.date("%H"))
        local greeting = hour < 12 and "Good Morning" or hour < 18 and "Good Afternoon" or "Good Evening"
        return {
          "",
          "  ███╗   ██╗ █████╗ ███╗   ███╗ █████╗ ███████╗████████╗███████╗",
          "  ████╗  ██║██╔══██╗████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝",
          "  ██╔██╗ ██║███████║██╔████╔██║███████║███████╗   ██║   █████╗  ",
          "  ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ",
          "  ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗",
          "  ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝",
          "",
          "                    " .. greeting .. ", " .. (os.getenv("USER") or "user") .. "!",
          "",
        }
      end,

      sections = {
        { key = "f", desc = "Find File", action = function() vim.cmd("Telescope find_files") end, icon = "󰈞 " },
        { key = "r", desc = "Recent Files", action = function() vim.cmd("Telescope oldfiles") end, icon = "󰋚 " },
        { key = "g", desc = "Find Text", action = function() vim.cmd("Telescope live_grep") end, icon = "󰊄 " },
        { key = "n", desc = "New File", action = function() vim.cmd("enew") end, icon = " " },
        { key = "c", desc = "Configuration", action = function() vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua") end, icon = " " },
        { key = "l", desc = "Lazy", action = function() vim.cmd("Lazy") end, icon = "󰒲 " },
        { key = "s", desc = "Restore Session", action = function() vim.cmd("SessionRestore") end, icon = " " },
        { key = "q", desc = "Quit", action = function() vim.cmd("qa") end, icon = "󰩈 " },
      },

      footer = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        local version = vim.version()
        local cwd = vim.fn.getcwd()
        return string.format(
          "⚡ Loaded %d/%d plugins in %dms | Neovim v%d.%d.%d | %s",
          stats.loaded,
          stats.count,
          ms,
          version.major,
          version.minor,
          version.patch,
          vim.fn.fnamemodify(cwd, ":t")
        )
      end,

      spacing = {
        header_padding = 2,
        section_padding = 1,
        footer_padding = 2,
      },

      window = {
        width = 0.8,
        height = 0.8,
        border = "rounded",
      },
    })
  end,

  -- For lazy.nvim plugin spec
  lazy_spec = {
    "abhilash26/namaste.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      auto_open = true,
      -- Add your configuration here
    },
  },
}

