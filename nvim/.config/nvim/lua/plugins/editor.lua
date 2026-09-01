-- Editor plugins: file tree, fuzzy finder, mini utilities, autopairs
return {
  -- File tree (replaces NERDTree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
    },
    opts = {
      filesystem = {
        filtered_items = { visible = true, hide_dotfiles = false },
        follow_current_file = { enabled = true },
      },
    },
  },

  -- Fuzzy finder (replaces fzf.vim)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<C-p>",      "<cmd>Telescope find_files<cr>",  desc = "Find files" },
      { "<leader>b",  "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<leader>g",  "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
      },
    },
  },

  -- mini.nvim suite (surround, comment, ai text objects — replaces tpope plugins + auto-pairs)
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "BufReadPost",
    config = function()
      require("mini.surround").setup()
      require("mini.comment").setup()
      require("mini.ai").setup()
      require("mini.pairs").setup()
    end,
  },
}
