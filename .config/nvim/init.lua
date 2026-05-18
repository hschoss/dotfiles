-- set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- set clipboard
vim.opt.clipboard = "unnamedplus"

-----------------------
-- Basic Preferences --
-----------------------
vim.opt.number = true                          -- show line numbers
vim.opt.relativenumber = true                  -- show relative line numbers
vim.opt.tabstop = 8                            -- tab width = 8
vim.opt.shiftwidth = 8                         -- indent width = 8
vim.opt.expandtab = false                      -- use spaces, not tabs
vim.opt.wrap = false                           -- no line wrap
vim.opt.ignorecase = true                      -- ignore case in search
vim.opt.smartcase = true                       -- case-sensitive for uppercase
vim.opt.termguicolors = true                   -- enable true color
vim.opt.cursorline = true                      -- highlight current line
vim.opt.splitbelow = true                      -- horizontal split below
vim.opt.splitright = true                      -- vertical split right
vim.opt.signcolumn = "yes"                     -- always show sign column
vim.opt.textwidth = 78                         -- max text width
vim.opt.formatoptions:append("t")              -- auto-wrap text


---------------
-- Shortcuts --
---------------
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>') -- quick-save
vim.keymap.set('n', ';', ':')                  -- make missing : less annoying

vim.keymap.set('n', '<C-j>', '<Esc>')          -- Ctrl+j and Ctrl+k as Esc
vim.keymap.set('i', '<C-j>', '<Esc>')
vim.keymap.set('v', '<C-j>', '<Esc>')
vim.keymap.set('s', '<C-j>', '<Esc>')
vim.keymap.set('x', '<C-j>', '<Esc>')
vim.keymap.set('c', '<C-j>', '<Esc>')
vim.keymap.set('o', '<C-j>', '<Esc>')
vim.keymap.set('l', '<C-j>', '<Esc>')
vim.keymap.set('t', '<C-j>', '<Esc>')

-- Ctrl-j is a little awkward unfortunately:
-- https://github.com/neovim/neovim/issues/5916
-- So we also map Ctrl+k
vim.keymap.set('n', '<C-k>', '<Esc>')
vim.keymap.set('i', '<C-k>', '<Esc>')
vim.keymap.set('v', '<C-k>', '<Esc>')
vim.keymap.set('s', '<C-k>', '<Esc>')
vim.keymap.set('x', '<C-k>', '<Esc>')
vim.keymap.set('c', '<C-k>', '<Esc>')
vim.keymap.set('o', '<C-k>', '<Esc>')
vim.keymap.set('l', '<C-k>', '<Esc>')
vim.keymap.set('t', '<C-k>', '<Esc>')
-- Ctrl+h to stop searching
vim.keymap.set('v', '<C-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-h>', '<cmd>nohlsearch<cr>')

-- Neat X clipboard integration
-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
vim.keymap.set('n', '<leader>p', '<cmd>read !wl-paste<cr>')
vim.keymap.set('n', '<leader>c', '<cmd>w !wl-copy<cr><cr>')
-- <leader><leader> toggles between buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')
-- <leader>, shows/hides hidden characters
vim.keymap.set('n', '<leader>,', ':set invlist<cr>')
-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')
-- open new file adjacent to current file
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')


-- disable arrow keys
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')
-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

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


-- Dies sollte VOR dem Laden des Farbschemas gesetzt werden
vim.opt.termguicolors = true
vim.opt.background = 'dark' -- Oder 'light'

-- Jetzt das Farbschema laden
vim.cmd.colorscheme 'default'

-- Stellt sicher, dass das rmarkdown.lua Skript geladen wird
require("rmarkdown")

local function insert_date(format)
  return function()
    return os.date(format)
  end
end

-- Funktion für den Zeitstempel (inkl. Sekunden)
local function get_timestamp()
  -- Format: Jahr-Monat-Tag Stunde:Minute:Sekunde
  return os.date("%Y-%m-%d %H:%M:%S")
end

-- Das ergonomische Mapping
-- 'i' steht für Insert Mode
-- 'expr = true' erlaubt es uns, den Rückgabewert der Funktion direkt zu tippen
vim.keymap.set('i', 'ddate', get_timestamp, { expr = true, desc = "Fügt aktuelles Datum & Zeit ein" })

