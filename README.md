![Lines of code](https://img.shields.io/tokei/lines/git.sr.ht/~nedia/auto-format.nvim?style=flat-square)

Open an issue [here](https://todo.sr.ht/~nedia/nvim).

# AutoFormat

Extremely simple auto format plugin.

We're creating an autocmd that runs on `BufWritePre` - the primary function of
this plugin is to prefer [`null-ls`](https://github.com/jose-elias-alvarez/null-ls.nvim)
for formatting over our LSP client.

On `BufWritePre` events, in the event that `null-ls` is present, we check if
a `formatting` source has been registered for the filetype of the buffer being
saved. If there is, we run the `null-ls` formatter, otherwise, we try our LSP
client.

In case you need a larger `timeout` duration, you can configure it. If you'd
prefer to not auto format certain filetypes, they can be defined. If you'd like
to prefer LSP client formatting, then remove the `null-ls` formatting source
honestly, but for some reason I've provided an option to `prefer_lsp` for some
filetypes.

# Installing

## [lazy](https://github.com/folke/lazy.nvim)

```lua
{
  "https://git.sr.ht/~nedia/auto-format.nvim",
  event = "BufWinEnter",
  config = function()
    require("auto-format").setup()
  end
}
```

## [packer](https://github.com/wbthomason/packer.nvim)

```lua
{
  "https://git.sr.ht/~nedia/auto-format.nvim",
  config = function()
    require("auto-format").setup()
  end
}
```

## [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'https://git.sr.ht/~nedia/auto-format.nvim'
lua require("auto-format").setup()
```

# Configuring

```lua
require("auto-save").setup({
  -- The name of the augroup.
  augroup_name = "AutoFormat",

  -- If formatting takes longer than this amount of time, it will fail. Having no
  -- timeout at all tends to be ugly - larger files, complex or poor formatters
  -- will struggle to format within whatever the default timeout
  -- `vim.lsp.buf.format` uses.
  M.timeout = 2000,

  -- These filetypes will not be formatted automatically.
  exclude_ft = {},

  -- Prefer formatting via LSP for these filetypes.
  prefer_lsp = {},
})
```
