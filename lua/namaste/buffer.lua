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

-- Create fullscreen window (no floating)
function M.create_window(buf)
  -- Switch to the buffer in current window
  vim.api.nvim_set_current_buf(buf)
  local win = vim.api.nvim_get_current_win()

  -- Modern window options (0.11+)
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].colorcolumn = "" -- Turn off colorcolumn
  vim.wo[win].statusline = " " -- Empty statusline for THIS window only

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

  -- Create window (fullscreen)
  local win = M.create_window(buf)
  if not win then
    return
  end
  _state.win_id = win

  -- Render content
  require("namaste.render").render(buf)

  -- Setup keymaps
  M.setup_keymaps(buf)

  -- Set up autocmds for cleanup
  local augroup = vim.api.nvim_create_augroup("NamasteBuffer", { clear = true })

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    group = augroup,
    once = true,
    callback = function()
      _state.buf_id = nil
      _state.win_id = nil
    end,
  })

  -- Hide tabline when entering namaste buffer (affects entire editor, but temporary)
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    group = augroup,
    callback = function()
      -- Store current values
      if not _state.saved_showtabline then
        _state.saved_showtabline = vim.o.showtabline
        _state.saved_laststatus = vim.o.laststatus
      end
      -- Hide UI elements temporarily
      vim.o.showtabline = 0
      vim.o.laststatus = 0
    end,
  })

  -- Restore UI elements when leaving namaste buffer
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    group = augroup,
    callback = function()
      -- Restore UI elements
      if _state.saved_showtabline then
        vim.o.showtabline = _state.saved_showtabline
      end
      if _state.saved_laststatus then
        vim.o.laststatus = _state.saved_laststatus
      end
    end,
  })
end

function M.close()
  if _state.buf_id and vim.api.nvim_buf_is_valid(_state.buf_id) then
    -- Delete the buffer (this will trigger BufWipeout and restore UI)
    vim.api.nvim_buf_delete(_state.buf_id, { force = true })
  end
end

return M

