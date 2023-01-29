local M = {}

-- The name of the augroup.
M.augroup_name = "AutoFormat"

M.timeout = 2000

M.exclude_ft = {}

-- Prefer formatting via LSP for these filetypes.
M.prefer_lsp = {}

return M
