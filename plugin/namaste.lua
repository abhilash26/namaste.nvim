-- Plugin initialization file for lazy loading
-- This file is loaded by Neovim when the plugin is used

-- Create commands
vim.api.nvim_create_user_command("Namaste", function()
  require("namaste").open()
end, {
  desc = "Open namaste welcome screen",
})

vim.api.nvim_create_user_command("NamasteClose", function()
  require("namaste").close()
end, {
  desc = "Close namaste welcome screen",
})

-- Auto-open on VimEnter if configured
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("NamasteAutoOpen", { clear = true }),
  once = true,
  callback = function()
    -- Only trigger if namaste is already loaded (user called setup)
    local ok, namaste = pcall(require, "namaste")
    if ok and namaste then
      local config = require("namaste.config").options
      if config and config.auto_open then
        -- Check if no files were opened
        if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
          vim.schedule(function()
            namaste.open()
          end)
        end
      end
    end
  end,
})

