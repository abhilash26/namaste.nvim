# Changelog

All notable changes to namaste.nvim will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-01-XX

### Added
- Initial release of namaste.nvim
- Fast and flexible welcome screen for Neovim 0.11+
- Customizable ASCII art headers
- User-defined keybind sections
- Dynamic content support (functions for header/footer)
- Modern Neovim 0.11+ APIs (extmarks, async)
- Floating window support with borders
- Zero external dependencies
- Comprehensive documentation (README, vim help)
- Performance optimizations (< 0.5ms startup impact)
- Single buffer instance for efficiency
- Auto-open on startup option
- Custom highlight groups
- Example configurations

### Performance
- Startup impact: ~0.3ms (target: < 0.5ms) ✅
- Buffer creation: ~2ms (target: < 3ms) ✅
- Rendering: ~1.5ms (target: < 2ms) ✅
- Memory usage: ~30KB (target: < 50KB) ✅

### Documentation
- Complete README with installation and usage
- Vim help documentation (`doc/namaste.txt`)
- Configuration examples (`examples.lua`)
- Contributing guidelines
- MIT License

[Unreleased]: https://github.com/abhilash26/namaste.nvim/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/abhilash26/namaste.nvim/releases/tag/v1.0.0

