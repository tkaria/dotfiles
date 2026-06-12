-- Treesitter: syntax highlighting, indentation, folding
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "c", "css", "dockerfile", "go", "html",
        "javascript", "json", "lua", "markdown", "markdown_inline",
        "python", "regex", "rust", "toml", "typescript", "vim",
        "vimdoc", "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
