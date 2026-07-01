-- LSP: Mason (installer) + nvim-lspconfig
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "gopls",
        "rust_analyzer",
        "dockerls",
      },
      automatic_installation = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- on_attach: keymaps active only when LSP attaches
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd",         vim.lsp.buf.definition,       "Go to definition")
        map("gD",         vim.lsp.buf.declaration,      "Go to declaration")
        map("gr",         vim.lsp.buf.references,       "Go to references")
        map("gi",         vim.lsp.buf.implementation,   "Go to implementation")
        map("K",          vim.lsp.buf.hover,            "Hover docs")
        map("<leader>rn", vim.lsp.buf.rename,           "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action,      "Code action")
        map("<leader>f",  function() vim.lsp.buf.format({ async = true }) end, "Format")
        map("[d",         vim.diagnostic.goto_prev,     "Prev diagnostic")
        map("]d",         vim.diagnostic.goto_next,     "Next diagnostic")
      end

      -- Configure each server
      local servers = {
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        },
        ts_ls = {},
        pyright = {},
        gopls = {},
        rust_analyzer = {},
        dockerls = {},
      }

      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, config))
      end
    end,
  },
}
