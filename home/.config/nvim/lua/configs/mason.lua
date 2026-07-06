local lspconfig = require "lspconfig"
local mason_lspconfig = require "mason-lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local lsp = require "configs.lspconfig"

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(lsp.servers),
  handlers = {
    function(server_name)
      local opts = lsp.servers[server_name] or {}
      lspconfig[server_name].setup(vim.tbl_extend("force", {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
      }, opts))
    end,
  },
}
