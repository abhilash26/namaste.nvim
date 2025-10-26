local M = {}

local _state = {
  buf_id = nil,
  win_id = nil,
  ns_id = vim.api.nvim_create_namespace("namaste"),
}

-- Create buffer with modern options
function M.create_buffer()
  local buf = vim.api.nvim_create_buf(false, true)

  -- Use vim.bo for cleaner API (0.11+)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "namaste"

  return buf
end

-- Modern window creation with floating support
function M.create_window(buf)
  local config = require("namaste.config").options
  local ui = vim.api.nvim_list_uis()[1]

  if not ui then
    vim.notify("[namaste] No UI available", vim.log.levels.ERROR)
    return nil
  end

  local width = math.floor(ui.width * config.window.width)
  local height = math.floor(ui.height * config.window.height)

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((ui.width - width) / 2),
    row = math.floor((ui.height - height) / 2),
    style = "minimal",
    border = config.window.border,
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Modern window options (0.11+)
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"

  return win
end

-- Set up keymaps using modern vim.keymap.set (0.11+)
function M.setup_keymaps(buf)
  local config = require("namaste.config").options

  -- Close buffer mappings
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, function()
      M.close()
    end, {
      buffer = buf,
      silent = true,
      desc = "Close namaste",
    })
  end

  -- Section keymaps
  for _, section in ipairs(config.sections) do
    vim.keymap.set("n", section.key, function()
      M.close()
      vim.schedule(function()
        if type(section.action) == "function" then
          section.action()
        else
          vim.cmd(section.action)
        end
      end)
    end, {
      buffer = buf,
      silent = true,
      desc = section.desc,
    })
  end

  -- Enter to execute action on current line
  vim.keymap.set("n", "<CR>", function()
    local line = vim.fn.line(".")
    local sections_start = require("namaste.render").get_sections_start_line()
    local section_idx = line - sections_start + 1

    if section_idx > 0 and section_idx <= #config.sections then
      local section = config.sections[section_idx]
      M.close()
      vim.schedule(function()
        if type(section.action) == "function" then
          section.action()
        else
          vim.cmd(section.action)
        end
      end)
    end
  end, {
    buffer = buf,
    silent = true,
    desc = "Execute action",
  })
end

-- Main entry point
function M.create_or_show()
  -- Reuse existing buffer if configured
  local config = require("namaste.config").options
  if config.single_instance and _state.buf_id and vim.api.nvim_buf_is_valid(_state.buf_id) then
    if _state.win_id and vim.api.nvim_win_is_valid(_state.win_id) then
      vim.api.nvim_set_current_win(_state.win_id)
      return
    end
  end

  -- Create new buffer
  local buf = M.create_buffer()
  _state.buf_id = buf

  -- Create window first to get proper dimensions
  local win = M.create_window(buf)
  if not win then
    return
  end
  _state.win_id = win

  -- Render content
  require("namaste.render").render(buf)

  -- Setup keymaps
  M.setup_keymaps(buf)

  -- Set up autocmd for cleanup
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      _state.buf_id = nil
      _state.win_id = nil
    end,
  })
end

function M.close()
  if _state.win_id and vim.api.nvim_win_is_valid(_state.win_id) then
    vim.api.nvim_win_close(_state.win_id, true)
  end
end

return M

