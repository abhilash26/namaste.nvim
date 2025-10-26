local M = {}

-- Performance cache
local _cache = {
  sections_start_line = 0,
  last_win_width = nil,
  last_win_height = nil,
  centered_header = nil,
  centered_sections = nil,
  content_lines_count = nil,
}

-- Clear cache when window dimensions change
local function clear_cache_if_needed(win_width, win_height)
  if _cache.last_win_width ~= win_width or _cache.last_win_height ~= win_height then
    _cache.last_win_width = win_width
    _cache.last_win_height = win_height
    _cache.centered_header = nil
    _cache.centered_sections = nil
    _cache.content_lines_count = nil
  end
end

-- Get sections start line (for keybind navigation)
function M.get_sections_start_line()
  return _cache.sections_start_line
end

-- Center text helper
function M.center_text(text, width)
  local text_width = vim.fn.strdisplaywidth(text)
  if text_width >= width then
    return text
  end

  local padding = math.floor((width - text_width) / 2)
  return string.rep(" ", padding) .. text
end

-- Calculate vertical padding for centering
function M.calculate_vertical_padding(total_lines, win_height)
  if total_lines >= win_height then
    return 0
  end
  return math.floor((win_height - total_lines) / 2)
end

-- Main render function using 0.11+ APIs with caching
function M.render(buf)
  local config = require("namaste.config").options
  local ns_id = vim.api.nvim_create_namespace("namaste")

  -- Get window dimensions
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)

  -- Clear cache if window size changed
  clear_cache_if_needed(win_width, win_height)

  -- Build content
  local lines = {}
  local highlights = {}

  -- Add header with caching
  local header = config.header
  if type(header) == "function" then
    header = header()
  end
  if type(header) == "string" then
    header = vim.split(header, "\n")
  end

  -- Cache centered header
  if not _cache.centered_header then
    _cache.centered_header = {}
    for _, line in ipairs(header) do
      table.insert(_cache.centered_header, M.center_text(line, win_width))
    end
  end

  -- Count total content lines for vertical centering (cached)
  if not _cache.content_lines_count then
    _cache.content_lines_count = #header
      + config.spacing.header_padding
      + (#config.sections * (1 + config.spacing.section_padding))

    -- Add quote if enabled
    if config.quote and config.quote.enabled then
      _cache.content_lines_count = _cache.content_lines_count + 2 + config.spacing.quote_padding
    end

    -- Add footer if present
    local footer = config.footer
    if type(footer) == "function" then
      footer = footer()
    end
    if footer then
      if type(footer) == "string" then
        footer = vim.split(footer, "\n")
      end
      _cache.content_lines_count = _cache.content_lines_count + #footer + config.spacing.footer_padding
    end
  end

  -- Add vertical padding to center content
  local vertical_padding = M.calculate_vertical_padding(_cache.content_lines_count, win_height)
  for _ = 1, vertical_padding do
    table.insert(lines, "")
  end

  -- Add header with highlights
  for i, line in ipairs(_cache.centered_header) do
    table.insert(lines, line)
    -- Add header highlight for ASCII art color
    table.insert(highlights, {
      line = #lines - 1,
      col_start = 0,
      col_end = -1,
      hl_group = config.highlights.header,
    })
  end

  -- Add spacing
  for _ = 1, config.spacing.header_padding do
    table.insert(lines, "")
  end

  -- Track sections start
  _cache.sections_start_line = #lines + 1

  -- Add sections with caching
  if not _cache.centered_sections then
    _cache.centered_sections = {}
    for _, section in ipairs(config.sections) do
      local icon = section.icon or ""
      local key_text = string.format("[%s]", section.key)
      local desc_text = section.desc
      local full_line = string.format("  %s%s  %s", icon, key_text, desc_text)
      local centered_line = M.center_text(full_line, win_width)

      -- Store centered line and highlight positions
      local key_start = centered_line:find("%[")
      local key_end = centered_line:find("%]")

      table.insert(_cache.centered_sections, {
        line = centered_line,
        key_start = key_start,
        key_end = key_end,
      })
    end
  end

  -- Add cached sections
  for _, section_data in ipairs(_cache.centered_sections) do
    table.insert(lines, section_data.line)
    local line_num = #lines - 1

    if section_data.key_start and section_data.key_end then
      local icon_start = 0
      local desc_start = section_data.key_end + 3

      table.insert(highlights, {
        line = line_num,
        col_start = icon_start,
        col_end = section_data.key_start,
        hl_group = config.highlights.icon,
      })

      table.insert(highlights, {
        line = line_num,
        col_start = section_data.key_start,
        col_end = section_data.key_end + 1,
        hl_group = config.highlights.key,
      })

      table.insert(highlights, {
        line = line_num,
        col_start = desc_start,
        col_end = -1,
        hl_group = config.highlights.desc,
      })
    end

    -- Add spacing
    for _ = 1, config.spacing.section_padding do
      table.insert(lines, "")
    end
  end

  -- Add quote if enabled
  if config.quote and config.quote.enabled then
    for _ = 1, config.spacing.quote_padding do
      table.insert(lines, "")
    end

    local utils = require("namaste.utils")
    local quote
    if config.quote.custom_quotes and #config.quote.custom_quotes > 0 then
      local random_index = math.random(1, #config.quote.custom_quotes)
      quote = config.quote.custom_quotes[random_index]
    else
      quote = utils.get_random_quote()
    end

    local quote_text = '"' .. quote.text .. '"'
    local author_text = "— " .. quote.author

    local centered_quote = M.center_text(quote_text, win_width)
    local centered_author = M.center_text(author_text, win_width)

    table.insert(lines, centered_quote)
    table.insert(highlights, {
      line = #lines - 1,
      col_start = 0,
      col_end = -1,
      hl_group = config.highlights.quote,
    })

    table.insert(lines, centered_author)
    table.insert(highlights, {
      line = #lines - 1,
      col_start = 0,
      col_end = -1,
      hl_group = config.highlights.quote_author,
    })
  end

  -- Add footer
  local footer = config.footer
  if type(footer) == "function" then
    footer = footer()
  end
  if footer then
    if type(footer) == "string" then
      footer = vim.split(footer, "\n")
    end

    for _ = 1, config.spacing.footer_padding do
      table.insert(lines, "")
    end

    for _, line in ipairs(footer) do
      local centered = M.center_text(line, win_width)
      table.insert(lines, centered)
      table.insert(highlights, {
        line = #lines - 1,
        col_start = 0,
        col_end = -1,
        hl_group = config.highlights.footer,
      })
    end
  end

  -- Set lines (atomic operation)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  -- Apply highlights using extmarks (0.11+ optimized)
  -- Batch highlights for better performance
  for _, hl in ipairs(highlights) do
    pcall(vim.api.nvim_buf_set_extmark, buf, ns_id, hl.line, hl.col_start, {
      end_col = hl.col_end,
      hl_group = hl.hl_group,
      priority = 100,
    })
  end
end

return M

