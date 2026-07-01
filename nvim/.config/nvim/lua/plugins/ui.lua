-- UI plugins: colorscheme, statusline, bufferline, indent guides, notifications
return {
  -- Catppuccin colorscheme (Frappé — matches terminal + tmux)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,  -- load first
    lazy = false,
    opts = {
      flavour = "frappe",
      integrations = {
        cmp = true,
        gitsigns = true,
        neo_tree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    main = "ibl",
    opts = {},
  },

  -- Which-key (discoverability for <leader> bindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
