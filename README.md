# namaste.nvim 🙏

A minimalist, **blazingly fast** Neovim welcome screen plugin built with performance in mind.

> **Performance First** • **Utility Second** • **Aesthetics Third**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.11%2B-green.svg)](https://neovim.io)

## ✨ Features

- 🚀 **Blazingly Fast**: < 0.5ms startup impact, < 2ms render time (30-50% faster re-renders with caching)
- ⚡ **Performance Caching**: Smart caching for headers, sections, and color extraction
- 🎨 **Customizable**: User-defined ASCII art and keybinds
- 🌈 **Colored ASCII Art**: Header text uses theme-adaptive colors with bold emphasis
- 🔧 **Zero Dependencies**: Pure Neovim APIs, no external plugins required
- 🌙 **Modern**: Built with Neovim 0.11+ features (extmarks, modern APIs)
- 💡 **Smart Defaults**: Works great out of the box, auto-opens on startup
- 🎯 **Focused**: Does one thing well - welcome screen
- 📺 **Fullscreen**: Clean fullscreen buffer with no statusline, tabline, or colorcolumn
- 🤖 **Auto-Detection**: Automatically detects Telescope/fzf-lua, package managers, and session managers
- 📍 **Centered**: Content perfectly centered vertically in window
- 💬 **Quotes**: Inspirational programming quotes to supercharge your workflow
- 🌈 **Theme-Adaptive**: Intelligently adapts highlights to your colorscheme and updates dynamically

## 📸 Screenshots

```
  ███╗   ██╗ █████╗ ███╗   ███╗ █████╗ ███████╗████████╗███████╗
  ████╗  ██║██╔══██╗████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝
  ██╔██╗ ██║███████║██╔████╔██║███████║███████╗   ██║   █████╗
  ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝
  ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗
  ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝


                       󰈞 [f]  Find File
                       󰋚 [r]  Recent Files
                       󰊄 [g]  Find Text
                        [c]  Configuration
                       󰒲 [l]  Lazy
                       󰩈 [q]  Quit


                      Neovim v0.11.0 | myproject
```

## 📦 Requirements

- **Neovim**: 0.11.0 or later
- **Optional**: Nerd Font for icons

## 🚀 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "abhilash26/namaste.nvim",
  lazy = false, -- Load on startup
  priority = 1000, -- Load before other plugins
  opts = {
    -- Configuration here (auto_open is true by default)
  },
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "abhilash26/namaste.nvim",
  config = function()
    require("namaste").setup()
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'abhilash26/namaste.nvim'
```

Then in your `init.lua`:
```lua
require("namaste").setup()
```

## 🤖 Auto-Detection

namaste.nvim intelligently detects your setup and adapts automatically:

### Fuzzy Finders
- **Telescope** (`telescope.nvim`) - Uses `telescope.builtin.*` commands
- **fzf-lua** - Uses `fzf-lua.*` commands
- **Fallback** - Uses built-in Vim commands if neither is found

### Package Managers
- **lazy.nvim** - Shows "Lazy" keybind → `:Lazy`
- **mini.deps** - Shows "Mini.deps" keybind → `require("mini.deps").update()`
- **packer.nvim** - Shows "Plugins" keybind → `:PackerSync`
- **vim-plug** - Shows "Plugins" keybind → `:PlugUpdate`

### Session Managers
- **persistence.nvim** - Auto-adds "Restore Session" keybind
- **auto-session** - Auto-adds "Restore Session" keybind
- **possession.nvim** - Auto-adds "Restore Session" keybind
- **resession.nvim** - Auto-adds "Restore Session" keybind

**No configuration needed!** Just install the plugin and it adapts to your setup.

## ⚙️ Configuration

### Default Configuration

```lua
require("namaste").setup({
  -- Performance
  auto_open = true,               -- Auto-open on startup (default: true)
  single_instance = true,         -- Reuse buffer
  lazy_render = true,             -- Defer rendering

  -- ASCII Art (can be function, table, or string)
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
    enabled = true, -- Show random quote (default: true)
    -- Or provide custom quotes:
    -- custom_quotes = {
    --   { text = "Your custom quote", author = "Author Name" },
    -- }
  },

  -- Keybind sections (auto-generated by default based on detected tools)
  -- sections = nil means auto-detection is enabled
  -- Uncomment to override auto-detection:
  -- sections = {
  --   { key = "f", desc = "Find File", action = function() ... end, icon = "󰈞 " },
  --   ...
  -- },

  -- Footer (can be function, table, or string)
  footer = function()
    local version = vim.version()
    local cwd = vim.fn.getcwd()
    return string.format("Neovim v%d.%d.%d | %s", version.major, version.minor, version.patch, vim.fn.fnamemodify(cwd, ":t"))
  end,

  -- Display spacing
  spacing = {
    header_padding = 2,
    section_padding = 1,
    footer_padding = 2,
  },

  -- Highlight groups
  highlights = {
    header = "@markup.heading",
    key = "@number",
    icon = "@character",
    desc = "@string",
    footer = "@comment",
  },
})
```

## 🎨 Customization Examples

### Minimal Setup

```lua
require("namaste").setup({
  auto_open = true,
  header = "Welcome to Neovim!",
  sections = {
    { key = "f", desc = "Find File", action = ":Telescope find_files<CR>" },
    { key = "q", desc = "Quit", action = ":qa<CR>" },
  },
  footer = "",
})
```

### Dynamic Greeting

```lua
require("namaste").setup({
  header = function()
    local hour = tonumber(os.date("%H"))
    local greeting = hour < 12 and "Good Morning" or hour < 18 and "Good Afternoon" or "Good Evening"
    return {
      "",
      "  " .. greeting .. ", " .. os.getenv("USER") .. "!",
      "",
    }
  end,
})
```

### Custom ASCII Art

```lua
require("namaste").setup({
  header = {
    "    ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿ ",
    "  ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣿ ",
    "  ⣾⣿⡿⡁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⡟⢸ ",
    " ⢠⣿⠏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⡿⠃⠄⠹ ",
    " ⣾⠋⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢻⣿⣿⣿⡟⠁⠄⠄⠄ ",
    "",
    "            Neovim Custom Setup",
  },
})
```

### With Lazy.nvim Stats

```lua
require("namaste").setup({
  footer = function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    return "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
  end,
})
```

## 🎯 Usage

### Commands

- `:Namaste` - Open the welcome screen
- `:NamasteClose` - Close the welcome screen

### API

```lua
-- Open welcome screen
require("namaste").open()

-- Close welcome screen
require("namaste").close()

-- Update configuration at runtime
require("namaste").update_config({
  auto_open = true,
})
```

### Keybinds

Within the namaste buffer:
- Press any configured key (e.g., `f`, `r`, `g`) to execute its action
- Press `<CR>` on a line to execute that action
- Press `q` or `<Esc>` to close

## 🔧 Highlight Groups

You can customize colors by overriding these highlight groups:

```lua
vim.api.nvim_set_hl(0, "NamasteHeader", { fg = "#ff5555", bold = true })
vim.api.nvim_set_hl(0, "NamasteKey", { fg = "#50fa7b" })
vim.api.nvim_set_hl(0, "NamasteIcon", { fg = "#8be9fd" })
vim.api.nvim_set_hl(0, "NamasteDesc", { fg = "#f8f8f2" })
vim.api.nvim_set_hl(0, "NamasteFooter", { fg = "#6272a4", italic = true })
```

## 🚄 Performance

namaste.nvim is built for speed:

| Metric | Target | Actual |
|--------|--------|--------|
| Startup Impact | < 0.5ms | ✅ ~0.3ms |
| Buffer Creation | < 3ms | ✅ ~2ms |
| Rendering | < 2ms | ✅ ~1.5ms |
| Memory Usage | < 50KB | ✅ ~30KB |

Enable debug mode to see performance stats:
```lua
vim.g.namaste_debug = true
```

## 🎓 Inspiration

- [mini.starter](https://github.com/nvim-mini/mini.starter) - Clean API design
- [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) - Feature ideas
- [alpha-nvim](https://github.com/goolord/alpha-nvim) - Customization patterns

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Neovim team for the amazing editor and APIs
- All the plugin authors who inspired this project

---

**Made with ❤️ and ☕ for the Neovim community**

