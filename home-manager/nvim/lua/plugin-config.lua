-- Configure Treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- LSP setup
local lspconfig = require('lspconfig')

-- Rust
lspconfig.rust_analyzer.setup{}

-- TypeScript
lspconfig.ts_ls.setup{}

-- Python
lspconfig.pyright.setup{}

-- Lua
lspconfig.lua_ls.setup{}

-- Nix
lspconfig.nil_ls.setup{}

-- HTML, CSS, JSON
lspconfig.html.setup{}
lspconfig.cssls.setup{}
lspconfig.jsonls.setup{}

-- Add any additional plugin configurations here
