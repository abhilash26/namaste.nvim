# Quick Installation Guide

## Prerequisites

- Neovim 0.11.0 or later
- Optional: Nerd Font for icons

Check your Neovim version:
```bash
nvim --version
```

## Installation Methods

### Option 1: lazy.nvim (Recommended)

Add to your `~/.config/nvim/lua/plugins/namaste.lua`:

```lua
return {
  "abhilash26/namaste.nvim",
  lazy = false,     -- Load on startup
  priority = 1000,  -- Load before other plugins
  opts = {
    -- Configuration here (auto_open is true by default)
  },
}
```

### Option 2: packer.nvim

Add to your `~/.config/nvim/lua/plugins.lua`:

```lua
use {
  "abhilash26/namaste.nvim",
  config = function()
    require("namaste").setup({
      -- Configuration here (auto_open is true by default)
    })
  end
}
```

### Option 3: vim-plug

Add to your `~/.config/nvim/init.vim`:

```vim
Plug 'abhilash26/namaste.nvim'
```

Then in your `init.lua`:

```lua
require("namaste").setup()
```

### Option 4: Manual Installation

```bash
cd ~/.local/share/nvim/site/pack/plugins/start/
git clone https://github.com/abhilash26/namaste.nvim.git
```

Then in your `init.lua`:

```lua
require("namaste").setup()
```

## Quick Test

After installation, test it:

```bash
nvim
```

Then in Neovim:

```vim
:Namaste
```

You should see the welcome screen!

## Minimal Configuration

Add to your `init.lua`:

```lua
require("namaste").setup({
  -- auto_open is true by default

  sections = {
    { key = "f", desc = "Find File", action = ":Telescope find_files<CR>" },
    { key = "r", desc = "Recent", action = ":Telescope oldfiles<CR>" },
    { key = "q", desc = "Quit", action = ":qa<CR>" },
  },
})
```

## Keybindings

Inside namaste buffer:
- Press any configured key (e.g., `f`, `r`, `q`) to execute action
- Press `<Enter>` on a line to execute that action
- Press `q` or `<Esc>` to close

## Commands

- `:Namaste` - Open the welcome screen
- `:NamasteClose` - Close the welcome screen

## Getting Help

View the documentation:

```vim
:help namaste
```

## Troubleshooting

### Plugin doesn't load

Check if setup was called:
```lua
require("namaste").setup()
```

### Window doesn't appear

Try opening manually:
```vim
:Namaste
```

### Icons don't show

Install a Nerd Font: https://www.nerdfonts.com/

### Error messages

Enable debug mode:
```lua
vim.g.namaste_debug = true
```

## Next Steps

1. Read the full README.md
2. Check examples.lua for more configurations
3. Customize your header ASCII art
4. Add your favorite keybinds

Enjoy! 🙏

