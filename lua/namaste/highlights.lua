local M = {}

-- Define default highlight groups (0.11+ supports @markup.* groups)
function M.setup()
  local highlights = {
    NamasteHeader = { link = "Title" },
    NamasteKey = { link = "Number" },
    NamasteIcon = { link = "Special" },
    NamasteDesc = { link = "String" },
    NamasteFooter = { link = "Comment" },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M

