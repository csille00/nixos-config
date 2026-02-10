return {
  -- Disable default LazyVim LSP plugins
  { "neovim/nvim-lspconfig", enabled = false },
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },

  -- Add coc.nvim
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = "VeryLazy",
    config = function()
      -- Use coc.nvim defaults, no custom configuration
      -- Install language servers with :CocInstall coc-<extension>
      -- Example: :CocInstall coc-tsserver coc-json coc-rust-analyzer

      -- Navigate diagnostics (errors/warnings)
      vim.keymap.set("n", "]e", "<Plug>(coc-diagnostic-next)", { silent = true })
      vim.keymap.set("n", "[e", "<Plug>(coc-diagnostic-prev)", { silent = true })
    end,
  },
}
