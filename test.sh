#!/usr/bin/env bash

# Quick test script for namaste.nvim
# This creates a minimal test environment to try the plugin

set -e

echo "🙏 Testing namaste.nvim..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
PLUGIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "📁 Test directory: $TEMP_DIR"

# Create minimal init.lua for testing
cat > "$TEMP_DIR/init.lua" << 'EOF'
-- Minimal test configuration for namaste.nvim

-- Add plugin to runtime path
vim.opt.runtimepath:append(vim.fn.getcwd())

-- Setup plugin
require("namaste").setup({
  auto_open = false,

  header = {
    "",
    "  ███╗   ██╗ █████╗ ███╗   ███╗ █████╗ ███████╗████████╗███████╗",
    "  ████╗  ██║██╔══██╗████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝",
    "  ██╔██╗ ██║███████║██╔████╔██║███████║███████╗   ██║   █████╗  ",
    "  ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ",
    "  ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗",
    "  ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝",
    "",
    "                         TEST MODE",
    "",
  },

  sections = {
    { key = "t", desc = "Test Passed!", action = function() print("✅ Test works!") end },
    { key = "h", desc = "Help", action = ":help namaste<CR>" },
    { key = "q", desc = "Quit", action = ":qa<CR>" },
  },

  footer = function()
    local version = vim.version()
    return string.format("Testing on Neovim v%d.%d.%d", version.major, version.minor, version.patch)
  end,
})

-- Auto-open for testing
vim.cmd("Namaste")

print("🙏 namaste.nvim test loaded!")
print("Press 't' to test, 'h' for help, 'q' to quit")
EOF

echo "🚀 Starting Neovim with test configuration..."
echo ""

# Run Neovim with test config
cd "$PLUGIN_DIR"
nvim -u "$TEMP_DIR/init.lua" --noplugin

# Cleanup
echo ""
echo "🧹 Cleaning up..."
rm -rf "$TEMP_DIR"

echo "✅ Test complete!"

