local M = {}

-- Extract color from highlight group
local function get_hl_color(group, attr)
  local hl = vim.api.nvim_get_hl(0, { name = group })
  if hl and hl[attr] then
    return string.format("#%06x", hl[attr])
  end
  return nil
end

-- Calculate brightness of a color (0-255)
local function get_brightness(hex)
  if not hex then
    return 128
  end
  local r = tonumber(hex:sub(2, 3), 16) or 0
  local g = tonumber(hex:sub(4, 5), 16) or 0
  local b = tonumber(hex:sub(6, 7), 16) or 0
  -- Perceived brightness formula
  return (r * 299 + g * 587 + b * 114) / 1000
end

-- Check if background is dark
local function is_dark_theme()
  local bg = vim.o.background
  if bg == "dark" then
    return true
  elseif bg == "light" then
    return false
  end

  -- Fallback: check Normal background brightness
  local normal_bg = get_hl_color("Normal", "bg")
  if normal_bg then
    return get_brightness(normal_bg) < 128
  end

  return true -- Default to dark
end

-- Lighten or darken a color
local function adjust_color(hex, amount)
  if not hex then
    return nil
  end

  local r = tonumber(hex:sub(2, 3), 16) or 0
  local g = tonumber(hex:sub(4, 5), 16) or 0
  local b = tonumber(hex:sub(6, 7), 16) or 0

  -- Adjust each component
  r = math.max(0, math.min(255, r + amount))
  g = math.max(0, math.min(255, g + amount))
  b = math.max(0, math.min(255, b + amount))

  return string.format("#%02x%02x%02x", r, g, b)
end

-- Get complementary color with good contrast
local function get_accent_color()
  local is_dark = is_dark_theme()

  -- Try to get accent colors from common highlight groups
  local accent_groups = {
    "Function",
    "Keyword",
    "Type",
    "Identifier",
    "Special",
    "Constant",
  }

  for _, group in ipairs(accent_groups) do
    local fg = get_hl_color(group, "fg")
    if fg then
      local brightness = get_brightness(fg)
      -- Ensure good contrast
      if is_dark and brightness > 100 then
        return fg
      elseif not is_dark and brightness < 180 then
        return fg
      end
    end
  end

  -- Fallback to title color
  return get_hl_color("Title", "fg")
end

-- Smart highlight generation based on current theme
local function generate_smart_highlights()
  local is_dark = is_dark_theme()

  -- Get base colors from current theme
  local title_fg = get_hl_color("Title", "fg")
  local string_fg = get_hl_color("String", "fg")
  local number_fg = get_hl_color("Number", "fg")
  local comment_fg = get_hl_color("Comment", "fg")
  local special_fg = get_hl_color("Special", "fg")
  local normal_fg = get_hl_color("Normal", "fg")
  local normal_bg = get_hl_color("Normal", "bg")

  -- Get accent color for important elements
  local accent = get_accent_color()

  local highlights = {}

  -- Header: Use title color or bright accent
  if title_fg then
    highlights.NamasteHeader = { fg = title_fg, bold = true }
  else
    highlights.NamasteHeader = { link = "Title" }
  end

  -- Key: Use number color or accent with emphasis
  if number_fg then
    highlights.NamasteKey = { fg = number_fg, bold = true }
  elseif accent then
    highlights.NamasteKey = { fg = accent, bold = true }
  else
    highlights.NamasteKey = { link = "Number" }
  end

  -- Icon: Use special color with slight adjustment
  if special_fg then
    highlights.NamasteIcon = { fg = special_fg }
  elseif accent then
    -- Slightly dimmed accent for icons
    local dimmed = adjust_color(accent, is_dark and -20 or 20)
    highlights.NamasteIcon = { fg = dimmed or accent }
  else
    highlights.NamasteIcon = { link = "Special" }
  end

  -- Description: Use string color or normal text
  if string_fg then
    highlights.NamasteDesc = { fg = string_fg }
  elseif normal_fg then
    highlights.NamasteDesc = { fg = normal_fg }
  else
    highlights.NamasteDesc = { link = "String" }
  end

  -- Footer: Use dimmed comment color
  if comment_fg then
    highlights.NamasteFooter = { fg = comment_fg, italic = true }
  else
    highlights.NamasteFooter = { link = "Comment" }
  end

  -- Quote: Slightly brighter than comment, italic
  if comment_fg then
    local brighter = adjust_color(comment_fg, is_dark and 30 or -30)
    highlights.NamasteQuote = { fg = brighter or comment_fg, italic = true }
  else
    highlights.NamasteQuote = { link = "Comment", italic = true }
  end

  -- Quote Author: Same as footer
  if comment_fg then
    highlights.NamasteQuoteAuthor = { fg = comment_fg }
  else
    highlights.NamasteQuoteAuthor = { link = "Comment" }
  end

  return highlights
end

-- Apply highlights
local function apply_highlights()
  local highlights = generate_smart_highlights()

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Define default highlight groups with smart theme detection
function M.setup()
  -- Apply highlights immediately
  apply_highlights()

  -- Re-apply on colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("NamasteHighlights", { clear = true }),
    callback = function()
      -- Small delay to ensure colorscheme is fully loaded
      vim.defer_fn(function()
        apply_highlights()

        -- Refresh namaste buffer if it's open
        local namaste_buf = vim.fn.bufnr("namaste")
        if namaste_buf ~= -1 and vim.api.nvim_buf_is_valid(namaste_buf) then
          -- Trigger re-render by calling render if buffer is visible
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == namaste_buf then
              -- Re-render the buffer
              vim.schedule(function()
                require("namaste.render").render(namaste_buf)
              end)
              break
            end
          end
        end
      end, 50)
    end,
  })
end

return M

