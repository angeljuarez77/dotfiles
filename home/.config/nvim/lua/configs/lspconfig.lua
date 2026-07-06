-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local M = {}

M.servers = {
  bashls = {},
  cssls = {},
  eslint = {},
  html = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
  ts_ls = {},
  typos_lsp = {},
}

return M
