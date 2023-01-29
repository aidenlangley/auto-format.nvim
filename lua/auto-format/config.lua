local M = {}

-- The name of the augroup.
M.augroup_name = "AutoFormat"

-- If formatting takes longer than this amount of time, it will fail. Having no
-- timeout at all tends to be ugly - larger files, complex or poor formatters
-- will struggle to format within whatever the default timeout
-- `vim.lsp.buf.format` uses.
M.timeout = 2000

-- These filetypes will not be formatted automatically.
M.exclude_ft = {}

-- Prefer formatting via LSP for these filetypes.
M.prefer_lsp = {}

return M
