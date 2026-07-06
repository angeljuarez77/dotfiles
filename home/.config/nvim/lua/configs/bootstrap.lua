local M = {}

M.packages = {
  "bash-language-server",
  "css-lsp",
  "eslint-lsp",
  "html-lsp",
  "json-lsp",
  "lua-language-server",
  "typescript-language-server",
  "typos-lsp",
  "stylua",
  "prettier",
}

function M.mason()
  local registry = require "mason-registry"
  registry.refresh()

  vim.wait(120000, function()
    return pcall(function()
      return registry.get_package "stylua"
    end)
  end, 200)

  local mason_packages = vim.fn.stdpath "data" .. "/mason/packages/"

  local function package_ready(name)
    local path = mason_packages .. name
    return vim.fn.filereadable(path .. "/mason-receipt.json") == 1
  end

  for _, name in ipairs(M.packages) do
    local pkg = registry.get_package(name)
    if not pkg:is_installed() then
      pkg:install()
    end

    local ok = vim.wait(300000, function()
      return package_ready(name)
    end, 2000)

    if not ok then
      error("dnvim: Mason package not installed: " .. name)
    end
  end
end

return M
