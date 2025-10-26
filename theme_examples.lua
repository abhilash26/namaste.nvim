-- Example theme configurations for namaste.nvim
-- Place in your neovim config (init.lua or plugin config)

-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║                         THEME EXAMPLES                               ║
-- ╚══════════════════════════════════════════════════════════════════════╝

-- ══════════════════════════════════════════════════════════════════════
--  1. VIM-STARTIFY THEME
-- ══════════════════════════════════════════════════════════════════════
--
-- Minimal, MRU-focused layout inspired by vim-startify
-- Perfect for: Quick file access, session management
--
-- Features:
-- ✓ Compact spacing
-- ✓ 10 MRU files (number keys 1-9, 0)
-- ✓ 5 recent sessions
-- ✓ Minimal sections
-- ✓ No quotes (focused on workflow)
-- ══════════════════════════════════════════════════════════════════════

require("namaste").setup({
  theme = "startify",
})

-- Or with customizations:
require("namaste").setup({
  theme = "startify",
  mru_limit = 15, -- Show more files
  show_sessions = true, -- Enable sessions
})

-- ══════════════════════════════════════════════════════════════════════
--  2. DASHBOARD-NVIM THEME
-- ══════════════════════════════════════════════════════════════════════
--
-- Beautiful, spacious layout inspired by dashboard-nvim
-- Perfect for: Visual appeal, motivation, feature discovery
--
-- Features:
-- ✓ Spacious layout with padding
-- ✓ Hyper logo ASCII art
-- ✓ Inspirational quotes
-- ✓ 5 MRU files with icons
-- ✓ Rich action buttons
-- ✓ Package manager integration
-- ══════════════════════════════════════════════════════════════════════

require("namaste").setup({
  theme = "dashboard",
})

-- Or with customizations:
require("namaste").setup({
  theme = "dashboard",
  show_sessions = true, -- Add session support
  quote = {
    enabled = true,
    position = "above_sections", -- Move quote position
  },
})

-- ══════════════════════════════════════════════════════════════════════
--  3. CUSTOM THEME (Mix and Match)
-- ══════════════════════════════════════════════════════════════════════
--
-- Start with a theme and customize it
-- ══════════════════════════════════════════════════════════════════════

require("namaste").setup({
  theme = "dashboard", -- Start with dashboard

  -- Override specific parts
  header = function()
    return {
      "  ╔══════════════════════════════╗",
      "  ║   MY CUSTOM NEOVIM SETUP   ║",
      "  ╚══════════════════════════════╝",
    }
  end,

  -- Keep dashboard's spacious layout
  spacing = {
    header_padding = 3,
    section_padding = 2,
  },

  -- Add custom sections
  sections = {
    {
      key = "p",
      desc = "Projects",
      action = function()
        vim.cmd("Telescope projects")
      end,
      icon = "󰉋 ",
    },
    -- ... more custom sections
  },
})

-- ══════════════════════════════════════════════════════════════════════
--  4. THEME COMPARISON
-- ══════════════════════════════════════════════════════════════════════
--
-- Feature              Startify    Dashboard    Custom (nil)
-- ─────────────────────────────────────────────────────────────────────
-- ASCII Art            Simple      Beautiful    Your choice
-- MRU Files            10          5            5
-- Sessions             Yes         No           No
-- Quotes               No          Yes          Yes
-- Spacing              Compact     Spacious     Normal
-- Focus                Workflow    Beauty       Balanced
-- Sections             3           8            Auto-detect
-- ══════════════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════════════════
--  5. LAZY.NVIM CONFIGURATIONS
-- ══════════════════════════════════════════════════════════════════════

-- Startify theme with lazy.nvim:
{
  "your-username/namaste.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    theme = "startify",
  },
}

-- Dashboard theme with lazy.nvim:
{
  "your-username/namaste.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    theme = "dashboard",
  },
}

-- ══════════════════════════════════════════════════════════════════════
--  6. THEME SWITCHING AT RUNTIME
-- ══════════════════════════════════════════════════════════════════════

-- You can switch themes by reloading config:
vim.keymap.set("n", "<leader>ts", function()
  require("namaste").setup({ theme = "startify" })
  vim.cmd("Alpha") -- Reopen namaste
end, { desc = "Switch to Startify theme" })

vim.keymap.set("n", "<leader>td", function()
  require("namaste").setup({ theme = "dashboard" })
  vim.cmd("Alpha") -- Reopen namaste
end, { desc = "Switch to Dashboard theme" })

-- ══════════════════════════════════════════════════════════════════════
--  7. CREATING YOUR OWN THEME
-- ══════════════════════════════════════════════════════════════════════

-- Create: lua/namaste/themes/mytheme.lua

local M = {}

M.header = function()
  return {
    "  ┌─────────────────────┐",
    "  │   MY THEME NAME   │",
    "  └─────────────────────┘",
  }
end

M.footer = function()
  return "Custom Footer"
end

function M.config()
  return {
    header = M.header,
    footer = M.footer,
    show_mru = true,
    mru_limit = 8,
    sections = {
      -- Your custom sections
    },
  }
end

return M

-- Then use it:
require("namaste").setup({ theme = "mytheme" })

