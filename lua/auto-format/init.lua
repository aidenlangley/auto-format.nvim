local M = {}

local config = require("auto-format.config")

---@param filetype string
---@return boolean
local function excluded_ft(filetype, exclusion_list)
  for _, v in ipairs(exclusion_list) do
    if filetype == v then
      return true
    end
  end

  return false
end

---@param client table
---@return boolean
local function supports_formatting(client)
  return client.supports_method("textDocument/formatting")
end

---@param filetype string
local function get_filter(filetype)
  local ok, sources = pcall(require, "null-ls.sources")
  local prefer_null_ls = not excluded_ft(filetype, config.prefer_lsp)

  if ok and prefer_null_ls then
    return function(client)
      if #sources.get_available(filetype, require("null-ls").methods.FORMATTING) > 0 then
        return client.name == "null-ls"
      else
        return supports_formatting(client)
      end
    end
  else
    return function(client)
      return supports_formatting(client)
    end
  end
end

---@param opts table
local function format(opts)
  if vim.lsp.buf.format then
    vim.lsp.buf.format(opts)
  else
    vim.lsp.buf.formatting_sync(opts, opts.timeout_ms)
  end
end

local function create_autocmd()
  -- Write buffer when leaving Insert mode
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup(config.augroup_name, { clear = true }),
    pattern = "*",
    callback = function(args)
      local ft = vim.api.nvim_buf_get_option(args.buf or vim.api.nvim_get_current_buf(), "filetype")
      local valid_ft = not excluded_ft(ft, config.exclude_ft)

      if ft and valid_ft then
        format({
          filter = get_filter(ft),
          timeout_ms = config.timeout,
        })
      end
    end,
  })
end

function M.setup(opts)
  if opts then
    config.augroup_name = opts.augroup_name or config.augroup_name
    config.timeout = opts.timeout or config.timeout
    config.exclude_ft = opts.exclude_ft or config.exclude_ft
    config.prefer_lsp = opts.prefer_lsp or config.prefer_lsp
  end

  create_autocmd()
end

return M
