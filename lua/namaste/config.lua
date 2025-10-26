local M = {}

M.defaults = {
  -- Performance
  auto_open = true,
  single_instance = true,
  lazy_render = true, -- Defer rendering until visible

  -- Content display options (inspired by vim-startify & dashboard-nvim)
  show_mru = true, -- Show Most Recently Used files
  mru_limit = 5, -- Number of MRU files to show
  show_sessions = false, -- Show available sessions
  session_limit = 3, -- Number of sessions to show

  -- ASCII Art (function support for dynamic content)
  header = function()
    return {
      "  ███╗   ██╗ █████╗ ███╗   ███╗ █████╗ ███████╗████████╗███████╗",
      "  ████╗  ██║██╔══██╗████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝",
      "  ██╔██╗ ██║███████║██╔████╔██║███████║███████╗   ██║   █████╗  ",
      "  ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ",
      "  ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗",
      "  ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝",
    }
  end,

  -- Quote configuration
  quote = {
    enabled = true, -- Show random quote
    -- Or provide custom quotes:
    -- custom_quotes = {
    --   { text = "Your custom quote", author = "Author Name" },
    -- }
  },

  -- Keybind sections with auto-detection (will be populated in setup)
  sections = nil, -- Auto-generated based on detected tools

  -- Footer with dynamic content
  footer = function()
    local version = vim.version()
    local utils = require("namaste.utils")
    local project = utils.get_project_name()
    return string.format(
      "Neovim v%d.%d.%d | %s",
      version.major,
      version.minor,
      version.patch,
      project
    )
  end,

  -- Display options
  spacing = {
    header_padding = 2,
    section_padding = 1,
    footer_padding = 2,
    quote_padding = 2, -- Space before footer
    mru_padding = 1, -- Space between MRU items
    sessions_padding = 1, -- Space between session items
  },

  -- Modern highlight groups (0.11+ supports @markup.*)
  highlights = {
    header = "@markup.heading",
    key = "@number",
    icon = "@character",
    desc = "@string",
    footer = "@comment",
    quote = "@comment.note",
    quote_author = "@comment",
    mru_title = "@markup.strong",
    mru_icon = "@character",
    mru_path = "@string.special.path",
    mru_number = "@number",
    sessions_title = "@markup.strong",
    sessions_icon = "@character",
    sessions_name = "@string",
  },
}

-- Generate default sections based on detected tools
local function generate_default_sections()
  local utils = require("namaste.utils")
  local finder_cmds = utils.get_finder_commands()
  local pm_cmd = utils.get_package_manager_command()
  local session_cmd = utils.get_session_restore_command()
  local session_manager = utils.detect_session_manager()
  local pm_name = utils.detect_package_manager()

  local sections = {
    {
      key = "f",
      desc = "Find File",
      action = finder_cmds.find_files,
      icon = "󰈞 ",
    },
    {
      key = "r",
      desc = "Recent Files",
      action = finder_cmds.oldfiles,
      icon = "󰋚 ",
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
  }

  -- Add package manager if detected
  if pm_name ~= "none" then
    table.insert(sections, {
      key = "l",
      desc = pm_name == "lazy" and "Lazy" or pm_name == "mini.deps" and "Mini.deps" or "Plugins",
      action = pm_cmd,
      icon = "󰒲 ",
    })
  end

  -- Add session restore if detected
  if session_manager ~= "none" then
    table.insert(sections, {
      key = "s",
      desc = "Restore Session",
      action = session_cmd,
      icon = " ",
    })
  end

  -- Always add quit
  table.insert(sections, {
    key = "q",
    desc = "Quit",
    action = function()
      vim.cmd("quit")
    end,
    icon = "󰩈 ",
  })

  return sections
end

-- Use vim.validate for thorough checking
function M.setup(opts)
  opts = opts or {}

  vim.validate({
    auto_open = { opts.auto_open, "boolean", true },
    single_instance = { opts.single_instance, "boolean", true },
    header = { opts.header, { "table", "function", "string" }, true },
    sections = { opts.sections, "table", true },
    footer = { opts.footer, { "table", "function", "string" }, true },
    quote = { opts.quote, "table", true },
  })

  -- Generate default sections if not provided
  if not opts.sections then
    opts.sections = generate_default_sections()
  end

  M.options = vim.tbl_deep_extend("force", M.defaults, opts)

  -- Ensure sections exist even after merge
  if not M.options.sections then
    M.options.sections = generate_default_sections()
  end
end

return M

