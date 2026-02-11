return {
  -- Nix filetype support (syntax, indentation, filetype detection)
  { "LnL7/vim-nix", ft = "nix" },

  -- Add nix treesitter parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "nix" })
    end,
  },
}
