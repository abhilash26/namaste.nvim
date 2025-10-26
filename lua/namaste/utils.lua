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

-- Auto-detect fuzzy finder (Telescope or fzf-lua)
function M.detect_finder()
  -- Check for Telescope
  local has_telescope = pcall(require, "telescope")
  if has_telescope then
    return "telescope"
  end

  -- Check for fzf-lua
  local has_fzf = pcall(require, "fzf-lua")
  if has_fzf then
    return "fzf-lua"
  end

  -- Fallback to built-in
  return "builtin"
end

-- Get finder commands based on detected finder
function M.get_finder_commands()
  local finder = M.detect_finder()

  if finder == "telescope" then
    return {
      find_files = function()
        require("telescope.builtin").find_files()
      end,
      oldfiles = function()
        require("telescope.builtin").oldfiles()
      end,
      live_grep = function()
        require("telescope.builtin").live_grep()
      end,
    }
  elseif finder == "fzf-lua" then
    return {
      find_files = function()
        require("fzf-lua").files()
      end,
      oldfiles = function()
        require("fzf-lua").oldfiles()
      end,
      live_grep = function()
        require("fzf-lua").live_grep()
      end,
    }
  else
    -- Builtin fallbacks
    return {
      find_files = function()
        vim.cmd("edit")
      end,
      oldfiles = function()
        vim.cmd("browse oldfiles")
      end,
      live_grep = function()
        vim.cmd("vimgrep // **/*")
      end,
    }
  end
end

-- Auto-detect package manager
function M.detect_package_manager()
  -- Check for lazy.nvim
  local has_lazy = pcall(require, "lazy")
  if has_lazy then
    return "lazy"
  end

  -- Check for mini.deps
  local has_mini_deps = pcall(require, "mini.deps")
  if has_mini_deps then
    return "mini.deps"
  end

  -- Check for packer
  local has_packer = pcall(require, "packer")
  if has_packer then
    return "packer"
  end

  -- Check for vim-plug (check if plug#begin exists)
  if vim.fn.exists("*plug#begin") == 1 then
    return "vim-plug"
  end

  return "none"
end

-- Get package manager command
function M.get_package_manager_command()
  local pm = M.detect_package_manager()

  if pm == "lazy" then
    return function()
      vim.cmd("Lazy")
    end
  elseif pm == "mini.deps" then
    return function()
      require("mini.deps").update()
    end
  elseif pm == "packer" then
    return function()
      vim.cmd("PackerSync")
    end
  elseif pm == "vim-plug" then
    return function()
      vim.cmd("PlugUpdate")
    end
  else
    return function()
      vim.notify("No package manager detected", vim.log.levels.WARN)
    end
  end
end

-- Auto-detect session manager
function M.detect_session_manager()
  -- Check for persistence.nvim
  local has_persistence = pcall(require, "persistence")
  if has_persistence then
    return "persistence"
  end

  -- Check for auto-session
  local has_auto_session = pcall(require, "auto-session")
  if has_auto_session then
    return "auto-session"
  end

  -- Check for possession.nvim
  local has_possession = pcall(require, "possession")
  if has_possession then
    return "possession"
  end

  -- Check for resession.nvim
  local has_resession = pcall(require, "resession")
  if has_resession then
    return "resession"
  end

  return "none"
end

-- Get session restore command
function M.get_session_restore_command()
  local sm = M.detect_session_manager()

  if sm == "persistence" then
    return function()
      require("persistence").load()
    end
  elseif sm == "auto-session" then
    return function()
      require("auto-session").RestoreSession()
    end
  elseif sm == "possession" then
    return function()
      require("possession").load()
    end
  elseif sm == "resession" then
    return function()
      require("resession").load()
    end
  else
    return function()
      vim.cmd("source Session.vim")
    end
  end
end

-- Random quote generator
function M.get_random_quote()
  local quotes = {
    { text = "The only way to do great work is to love what you do.", author = "Steve Jobs" },
    { text = "Code is like humor. When you have to explain it, it's bad.", author = "Cory House" },
    { text = "First, solve the problem. Then, write the code.", author = "John Johnson" },
    { text = "Simplicity is the soul of efficiency.", author = "Austin Freeman" },
    { text = "Make it work, make it right, make it fast.", author = "Kent Beck" },
    { text = "Clean code always looks like it was written by someone who cares.", author = "Robert C. Martin" },
    { text = "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.", author = "Martin Fowler" },
    { text = "Programs must be written for people to read, and only incidentally for machines to execute.", author = "Harold Abelson" },
    { text = "The best error message is the one that never shows up.", author = "Thomas Fuchs" },
    { text = "Debugging is twice as hard as writing the code in the first place.", author = "Brian Kernighan" },
    { text = "It's not a bug – it's an undocumented feature.", author = "Anonymous" },
    { text = "Talk is cheap. Show me the code.", author = "Linus Torvalds" },
    { text = "Walking on water and developing software from a specification are easy if both are frozen.", author = "Edward V. Berard" },
    { text = "Programming isn't about what you know; it's about what you can figure out.", author = "Chris Pine" },
    { text = "The most disastrous thing that you can ever learn is your first programming language.", author = "Alan Kay" },
    { text = "Experience is the name everyone gives to their mistakes.", author = "Oscar Wilde" },
    { text = "In order to be irreplaceable, one must always be different.", author = "Coco Chanel" },
    { text = "Don't worry if it doesn't work right. If everything did, you'd be out of a job.", author = "Mosher's Law" },
    { text = "Perfection is achieved not when there is nothing more to add, but rather when there is nothing more to take away.", author = "Antoine de Saint-Exupery" },
    { text = "The function of good software is to make the complex appear to be simple.", author = "Grady Booch" },
  }

  local random_index = math.random(1, #quotes)
  return quotes[random_index]
end

return M

