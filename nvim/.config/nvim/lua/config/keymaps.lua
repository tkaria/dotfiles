-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search highlight (preserves <leader><space> muscle memory)
map("n", "<leader><space>", ":nohlsearch<CR>", opts)

-- Visual-line navigation (muscle memory from .vimrc)
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<S-l>", ":bnext<CR>", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines up/down
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)

-- Don't yank on paste
map("v", "p", '"_dP', opts)

-- Formatting
map("n", "<leader>q", "gqip", opts)

-- Toggle whitespace viz
map("n", "<leader>l", ":set list!<CR>", opts)
