local M = {}

-- Performance timer using vim.loop.hrtime()
function M.time_it(fn, name)
  local start = vim.loop.hrtime()
  fn()
  local duration = (vim.loop.hrtime() - start) / 1e6 -- Convert to ms

  if vim.g.namaste_debug then
    vim.notify(string.format("[namaste] %s took %.2fms", name, duration), vim.log.levels.DEBUG)
  end

  return duration
end

-- Async execution wrapper
function M.async(fn)
  vim.schedule(function()
    local ok, err = pcall(fn)
    if not ok then
      vim.notify("[namaste] Error: " .. tostring(err), vim.log.levels.ERROR)
    end
  end)
end

-- Safe action executor
function M.execute_action(action)
  if type(action) == "function" then
    local ok, err = pcall(action)
    if not ok then
      vim.notify("[namaste] Action failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  elseif type(action) == "string" then
    local ok, err = pcall(vim.cmd, action)
    if not ok then
      vim.notify("[namaste] Command failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

return M

