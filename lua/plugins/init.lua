return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "configs.treesitter"
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    config = function()
      require "configs.inline-diagnostics"
    end,
  },

  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.hlchunkline"
    end,
  },
  { "nvzone/volt", lazy = true },
  { "nvzone/menu", lazy = true },
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {
      border = true,
    },
    cmd = "FloatermToggle",
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_echo_preview_url = 1
    end,
  },
}
