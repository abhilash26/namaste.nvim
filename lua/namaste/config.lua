local M = {}

M.defaults = {
  -- Performance
  auto_open = true,
  single_instance = true,
  lazy_render = true, -- Defer rendering until visible

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

  -- Keybind sections with modern patterns
  sections = {
    {
      key = "f",
      desc = "Find File",
      action = function()
        vim.cmd("Telescope find_files")
      end,
      icon = "󰈞 ", -- Nerd font icon (optional)
    },
    {
      key = "r",
      desc = "Recent Files",
      action = function()
        vim.cmd("Telescope oldfiles")
      end,
      icon = "󰋚 ",
    },
    {
      key = "g",
      desc = "Find Text",
      action = function()
        vim.cmd("Telescope live_grep")
      end,
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
      key = "l",
      desc = "Lazy",
      action = function()
        vim.cmd("Lazy")
      end,
      icon = "󰒲 ",
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

  -- Footer with dynamic content
  footer = function()
    local version = vim.version()
    local stats = vim.fn.getcwd()
    return string.format(
      "Neovim v%d.%d.%d | %s",
      version.major,
      version.minor,
      version.patch,
      vim.fn.fnamemodify(stats, ":t")
    )
  end,

  -- Display options
  spacing = {
    header_padding = 2,
    section_padding = 1,
    footer_padding = 2,
  },

  -- Modern highlight groups (0.11+ supports @markup.*)
  highlights = {
    header = "@markup.heading",
    key = "@number",
    icon = "@character",
    desc = "@string",
    footer = "@comment",
  },
}

-- Use vim.validate for thorough checking
function M.setup(opts)
  opts = opts or {}

  vim.validate({
    auto_open = { opts.auto_open, "boolean", true },
    single_instance = { opts.single_instance, "boolean", true },
    header = { opts.header, { "table", "function", "string" }, true },
    sections = { opts.sections, "table", true },
    footer = { opts.footer, { "table", "function", "string" }, true },
  })

  M.options = vim.tbl_deep_extend("force", M.defaults, opts)
end

return M

