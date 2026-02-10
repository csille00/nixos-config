return {
  -- Disable LazyVim plugins that conflict with coc.nvim
  { "neovim/nvim-lspconfig", enabled = false },
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "saghen/blink.cmp", enabled = false },
  { "saghen/blink-copilot", enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false },
  { "folke/lazydev.nvim", enabled = false },
  { "folke/trouble.nvim", enabled = false },
  { "stevearc/conform.nvim", enabled = false },
  { "mfussenegger/nvim-lint", enabled = false },

  -- Add coc.nvim
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Let coc.nvim handle these
      vim.g.coc_global_extensions = {
        "coc-tsserver",
        "coc-json",
        "coc-eslint",
        "coc-prettier",
      }

      -- Use <tab> and <s-tab> to navigate completion list
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      vim.keymap.set("i", "<TAB>", [[coc#pum#visible() ? coc#pum#next(1) : "\<TAB>"]], opts)
      vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      vim.keymap.set("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Trigger completion
      vim.keymap.set("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

      -- Diagnostics navigation
      vim.keymap.set("n", "[d", "<Plug>(coc-diagnostic-prev)", { silent = true })
      vim.keymap.set("n", "]d", "<Plug>(coc-diagnostic-next)", { silent = true })

      -- GoTo navigation
      vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
      vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Hover documentation with K
      vim.keymap.set("n", "K", function()
        local cw = vim.fn.expand("<cword>")
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.fn["coc#rpc#ready"]() then
          vim.fn.CocActionAsync("doHover")
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end, { silent = true })

      -- Rename
      vim.keymap.set("n", "<leader>cr", "<Plug>(coc-rename)", { silent = true, desc = "Rename symbol" })

      -- Code action
      vim.keymap.set("n", "<leader>ca", "<Plug>(coc-codeaction-cursor)", { silent = true, desc = "Code action" })
      vim.keymap.set("v", "<leader>ca", "<Plug>(coc-codeaction-selected)", { silent = true, desc = "Code action" })

      -- Quick fix for current line
      vim.keymap.set("n", "<leader>cf", "<Plug>(coc-fix-current)", { silent = true, desc = "Quick fix" })

      -- Organize imports
      vim.keymap.set("n", "<leader>co", function()
        vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport")
      end, { silent = true, desc = "Organize imports" })

      -- Show all diagnostics
      vim.keymap.set("n", "<leader>cd", ":<C-u>CocList diagnostics<CR>", { silent = true, desc = "Diagnostics" })

      -- Highlight symbol under cursor on hold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          if vim.fn["coc#rpc#ready"]() then
            vim.fn.CocActionAsync("highlight")
          end
        end,
      })
    end,
  },
}
