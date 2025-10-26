# Contributing to namaste.nvim

First off, thank you for considering contributing to namaste.nvim! 🙏

## Code of Conduct

This project and everyone participating in it is governed by common sense and mutual respect. Be kind, be constructive, and help create a positive environment.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected behavior**
- **Actual behavior**
- **Neovim version** (`nvim --version`)
- **Configuration** (minimal reproducible config)
- **Screenshots** (if applicable)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Use case** - why is this enhancement useful?
- **Expected behavior**
- **Alternatives considered**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code, add tests (when applicable)
3. Ensure your code follows the existing style
4. Update documentation if needed
5. Write a clear commit message

## Development Setup

1. Clone your fork:
```bash
git clone https://github.com/abhilash26/namaste.nvim.git
cd namaste.nvim
```

2. Install dependencies:
- Neovim 0.11.0+
- (Optional) stylua for formatting

3. Format code:
```bash
stylua .
```

## Code Style

- Use **2 spaces** for indentation
- Follow existing patterns in the codebase
- Use **meaningful variable names**
- Add **comments** for complex logic
- Keep functions **small and focused**
- Prefer **functional programming** when possible

### Lua Style

```lua
-- Good
local function calculate_center(text, width)
  local padding = math.floor((width - #text) / 2)
  return string.rep(" ", padding) .. text
end

-- Bad
local function calc(t,w)
  return string.rep(" ",math.floor((w-#t)/2))..t
end
```

## Performance Guidelines

namaste.nvim prioritizes performance. When contributing:

1. **Profile your changes** - use `vim.g.namaste_debug = true`
2. **Avoid blocking operations** - use `vim.schedule` for async work
3. **Cache when possible** - reuse computed values
4. **Minimize API calls** - batch operations
5. **Test startup impact** - measure with `--startuptime`

### Performance Targets

- Startup impact: < 0.5ms
- Buffer creation: < 3ms
- Rendering: < 2ms
- Memory: < 50KB

## Testing

While we don't have a formal test suite yet, please manually test:

1. **Fresh install** - test with minimal config
2. **Different Neovim versions** - 0.11.0+
3. **Edge cases** - empty config, invalid options
4. **Performance** - check startup time impact

## Documentation

- Update README.md for user-facing changes
- Update doc/namaste.txt for API changes
- Add examples to examples.lua for common use cases
- Update CHANGELOG.md with your changes

## Commit Messages

Use clear, descriptive commit messages:

```
feat: add session restore integration
fix: correct window centering calculation
docs: update configuration examples
perf: optimize render pipeline with caching
refactor: simplify buffer management
```

Format:
- `feat:` - new feature
- `fix:` - bug fix
- `docs:` - documentation changes
- `perf:` - performance improvement
- `refactor:` - code refactoring
- `test:` - adding tests
- `chore:` - maintenance tasks

## Project Structure

```
namaste.nvim/
├── lua/namaste/
│   ├── init.lua        # Main entry point
│   ├── config.lua      # Configuration management
│   ├── buffer.lua      # Buffer creation & management
│   ├── render.lua      # Content rendering
│   ├── highlights.lua  # Highlight groups
│   └── utils.lua       # Helper utilities
├── plugin/
│   └── namaste.lua     # Plugin autoload
├── doc/
│   └── namaste.txt     # Vim help docs
└── examples.lua        # Configuration examples
```

## Module Responsibilities

- **init.lua**: Setup, API surface, lazy loading
- **config.lua**: Configuration validation and defaults
- **buffer.lua**: Buffer lifecycle, keymaps, window management
- **render.lua**: Content generation, centering, highlights
- **highlights.lua**: Highlight group definitions
- **utils.lua**: Helper functions, performance tracking

## Questions?

Feel free to open an issue with the `question` label!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

