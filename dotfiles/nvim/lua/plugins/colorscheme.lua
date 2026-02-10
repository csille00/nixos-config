return {
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- Ensure it's loaded before other UI-related plugins
    config = function()
      require("onedark").setup({
        style = "warm", -- Options: dark, darker, cool, deep, warm, warmer
        transparent = false, -- Set to true if you want a transparent background
        term_colors = true, -- Use terminal colors
      })
      require("onedark").load()
    end,
  },
}
