-- 0. Clipboard
vim.opt.clipboard = "unnamedplus"

-- 1. Leader key
vim.g.mapleader = " "

-- 2. Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.textwidth = 100
vim.opt.formatoptions:append("t")

-- 3. Keymaps (shortcuts)
local keymap = vim.keymap.set
keymap("n", "<leader>h", ":nohlsearch<CR>") -- clear search highlight

-- 4. Install lazy.nvim plugin manager if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 5. Plugins --

-- Ensure lazy is loaded
vim.opt.rtp:prepend("~/.local/share/nvim/site/pack/lazy/start/lazy.nvim")

-- Plugin setup
require("lazy").setup({
  -- Example plugin
   'ThePrimeagen/vim-be-good'
  -- Add other plugins here
})


-- 6. Colorscheme
vim.cmd.colorscheme("default")
