require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls" }

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      analyses = { unusedparams = true },
    },
  },
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
