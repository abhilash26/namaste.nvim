local M = {}

-- Cache for performance
local _state = {
  ns_id = nil, -- Namespace ID
  buf_id = nil, -- Buffer ID
  win_id = nil, -- Window ID
  config = nil, -- Runtime config
  loaded = false, -- Initialization state
}

-- Use vim.validate for type checking (0.11 improved)
function M.setup(opts)
  vim.validate({
    opts = { opts, "table", true },
  })

  -- Defer heavy initialization
  vim.schedule(function()
    require("namaste.config").setup(opts)
    require("namaste.highlights").setup()
    _state.loaded = true

    -- Auto-open if configured
    local config = require("namaste.config").options
    if config.auto_open then
      -- Only auto-open on startup if no files were opened
      if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
        M.open()
      end
    end
  end)
end

-- Async buffer creation
function M.open()
  if not _state.loaded then
    vim.notify("namaste.nvim: Please call setup() first", vim.log.levels.ERROR)
    return
  end

  vim.schedule(function()
    require("namaste.buffer").create_or_show()
  end)
end

-- Close the buffer
function M.close()
  require("namaste.buffer").close()
end

-- Update configuration at runtime
function M.update_config(opts)
  if not _state.loaded then
    vim.notify("namaste.nvim: Please call setup() first", vim.log.levels.ERROR)
    return
  end

  require("namaste.config").setup(opts)
end

return M

