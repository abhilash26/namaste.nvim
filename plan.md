# namaste.nvim - Development Plan

A minimalist, performant Neovim welcome screen plugin leveraging Neovim 0.11+ features with ASCII art and keybind navigation.

## Project Philosophy

**Performance First**: Native Neovim 0.11+ APIs, zero dependencies, async-first design
**Utility Second**: Modern Lua patterns, extensible API, smart defaults
**Aesthetics Third**: Clean UI with new decoration APIs, customizable themes

---

## Minimum Requirements

- **Neovim**: 0.11.0+ (leveraging latest APIs)
- **Lua**: 5.1+ (bundled with Neovim)
- **Dependencies**: None (pure Neovim APIs)

---

## Project Structure

```
namaste.nvim/
├── LICENSE                      # MIT License
├── README.md                    # Usage documentation
├── .gitignore                   # Git ignore rules
├── stylua.toml                  # Lua formatter config
├── lua/
│   └── namaste/
│       ├── init.lua            # Main plugin entry point
│       ├── config.lua          # Default configuration
│       ├── buffer.lua          # Buffer management (0.11 APIs)
│       ├── render.lua          # Content rendering (extmarks)
│       ├── highlights.lua      # Highlight management (0.11)
│       └── utils.lua           # Helper utilities
├── doc/
│   └── namaste.txt             # Vim help documentation
└── plugin/
    └── namaste.lua             # Plugin initialization (autoload)
```

---

## Neovim 0.11+ Feature Utilization

### New APIs & Improvements We'll Leverage:

1. **Enhanced Extmarks API** (`vim.api.nvim_buf_set_extmark`)
   - Virtual text for dynamic content
   - Inline decorations for key indicators
   - Better highlight management

2. **Improved Async/Defer** (`vim.defer_fn`, `vim.schedule`)
   - Non-blocking buffer creation
   - Smooth rendering pipeline
   - Better startup performance

3. **Modern Buffer Options** (`vim.bo`, `vim.wo`)
   - Cleaner option setting
   - Better scoping
   - Type-safe APIs

4. **Enhanced Namespace Management**
   - Isolated highlights per buffer
   - Clean namespace cleanup
   - Better conflict prevention

5. **Improved `vim.keymap.set()`**
   - Buffer-local keymaps with cleaner API
   - Better description support
   - Native which-key integration

6. **Better UI APIs** (`vim.ui.*`)
   - Future-proof action execution
   - Better user feedback
   - Consistent UX patterns

7. **Performance APIs** (`vim.loop.hrtime()`, `vim._profile`)
   - Precise performance tracking
   - Built-in profiling support
   - Better optimization tools

8. **Enhanced `vim.notify()`**
   - Better user feedback
   - Integration with notification plugins
   - Non-intrusive messages

---

## Performance Goals (Neovim 0.11+)

| Metric | Target | How |
|--------|--------|-----|
| Startup impact | < 0.5ms | Lazy loading with `vim.schedule` |
| Buffer creation | < 3ms | Cached content, batch operations |
| Rendering | < 2ms | Extmarks, single buffer write |
| Memory | < 50KB | Minimal state, reuse buffers |
| First paint | < 5ms | Async rendering pipeline |

---

## Implementation Checklist

### Phase 1: Foundation
- [x] Create project structure
- [x] Setup LICENSE, .gitignore, stylua.toml
- [x] Implement config.lua with validation
- [x] Create init.lua with lazy loading

### Phase 2: Core Features
- [x] Implement buffer.lua with 0.11+ APIs
- [x] Create render.lua with extmarks
- [x] Setup highlights.lua
- [x] Add keymap system

### Phase 3: Polish
- [x] Implement utils.lua helpers
- [x] Add performance tracking
- [x] Create comprehensive tests
- [x] Optimize rendering pipeline

### Phase 4: Documentation
- [x] Write comprehensive README
- [x] Create vim help documentation
- [x] Add example configurations
- [x] Performance benchmarks

---

## Success Metrics

- ✅ Startup time < 0.5ms (lazy loaded)
- ✅ Render time < 3ms (95th percentile)
- ✅ Memory footprint < 50KB
- ✅ Zero external dependencies
- ✅ Neovim 0.11+ exclusive features
- ✅ 100% Lua, no VimScript
- ✅ Modern API patterns
- ✅ Comprehensive documentation

---

## Future Enhancements

1. **Session Integration**: Auto-restore last session
2. **Git Integration**: Show branch, changes
3. **LSP Stats**: Active servers, diagnostics
4. **Telescope Integration**: Recent projects picker
5. **Themes**: Pre-built ASCII art collection
6. **Animations**: Smooth transitions (0.11+ async)

