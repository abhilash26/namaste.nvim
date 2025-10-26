local M = {}

local _cache = {
  sections_start_line = 0,
}

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

-- Main render function using 0.11+ APIs
function M.render(buf)
  local config = require("namaste.config").options
  local ns_id = vim.api.nvim_create_namespace("namaste")

  -- Build content
  local lines = {}
  local highlights = {}

  -- Add header
  local header = config.header
  if type(header) == "function" then
    header = header()
  end
  if type(header) == "string" then
    header = vim.split(header, "\n")
  end

  local win_width = vim.api.nvim_win_get_width(0)

  for _, line in ipairs(header) do
    table.insert(lines, M.center_text(line, win_width))
  end

  -- Add spacing
  for _ = 1, config.spacing.header_padding do
    table.insert(lines, "")
  end

  -- Track sections start
  _cache.sections_start_line = #lines + 1

  -- Add sections
  for _, section in ipairs(config.sections) do
    local icon = section.icon or ""
    local key_text = string.format("[%s]", section.key)
    local desc_text = section.desc
    local full_line = string.format("  %s%s  %s", icon, key_text, desc_text)

    local centered_line = M.center_text(full_line, win_width)
    table.insert(lines, centered_line)

    -- Store highlight info
    local line_num = #lines - 1
    local key_start = centered_line:find("%[")
    local key_end = centered_line:find("%]")

    if key_start and key_end then
      local icon_start = 0
      local desc_start = key_end + 3

      table.insert(highlights, {
        line = line_num,
        col_start = icon_start,
        col_end = key_start,
        hl_group = config.highlights.icon,
      })

      table.insert(highlights, {
        line = line_num,
        col_start = key_start,
        col_end = key_end + 1,
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

  -- Add footer
  local footer = config.footer
  if type(footer) == "function" then
    footer = footer()
  end
  if footer then
    for _ = 1, config.spacing.footer_padding do
      table.insert(lines, "")
    end

    if type(footer) == "string" then
      footer = vim.split(footer, "\n")
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
  for _, hl in ipairs(highlights) do
    pcall(vim.api.nvim_buf_set_extmark, buf, ns_id, hl.line, hl.col_start, {
      end_col = hl.col_end,
      hl_group = hl.hl_group,
      priority = 100,
    })
  end
end

return M

