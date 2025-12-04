local opt = vim.opt
local state_dir = vim.fn.stdpath('state')
local cache_dir = vim.fn.stdpath('cache')

vim.fn.mkdir(state_dir .. '/swap', 'p')
vim.fn.mkdir(state_dir .. '/undo', 'p')
vim.fn.mkdir(state_dir .. '/shada', 'p')
vim.fn.mkdir(cache_dir .. '/luac', 'p')

opt.directory = state_dir .. '/swap//'
opt.undodir = state_dir .. '/undo'
local spellfile = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'
opt.spellfile = spellfile
opt.spelllang = { 'en' }
if vim.fn.filereadable(spellfile) == 0 then
  vim.fn.writefile({}, spellfile)
end
local escaped_spellfile = vim.fn.fnameescape(spellfile)
pcall(vim.cmd, ('silent! mkspell! %s %s'):format(escaped_spellfile, escaped_spellfile))

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.colorcolumn = '100'

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.termguicolors = true

-- Explicit cursor highlight groups so colorschemes can override them
opt.guicursor = table.concat({
  'n-v-c:block-Cursor/lCursor',
  'sm:block-Cursor/lCursor',
  'i-ci:ver25-Cursor/lCursor',
  've:ver35-Cursor/lCursor',
  'r-cr:hor20-Cursor/lCursor',
  'o:hor50-Cursor/lCursor',
  't:block-TermCursor/TermCursor',
  'a:blinkwait700-blinkoff400-blinkon250',
}, ',')

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Highlight current line
vim.wo.cursorline = true

opt.scrolloff = 8

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  -- float = {
  --   border = 'rounded',
  --   format = function(d)
  --     return ('%s (%s) [%s]'):format(d.message, d.source, d.code or d.user_data.lsp.code)
  --   end,
  -- },
  underline = true,
  float = false,
  virtual_text = { current_line = true },
})

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for moving blocks.
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
--
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Always go to middle of the screen when movin up or down a page
vim.keymap.set('n', '<C-u>', '<C-u>zz<CR>')
vim.keymap.set('n', '<C-d>', '<C-d>zz<CR>')

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

if vim.fn.exists(':Messages') == 0 then
  vim.api.nvim_create_user_command('Messages', function()
    vim.cmd('messages')
  end, { desc = 'Show message history' })
end

-- [[ Unfold on open ]]
-- Since vim will start with all folds closed we need to open them all when a file is opened
opt.foldlevel = 20
-- local unfold_group = vim.api.nvim_create_augroup('Unfold', { clear = true })
-- vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
--   command = 'normal zR',
--   group = unfold_group,
--   pattern = '*',
-- })

-- Cycle through buffers
vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Toggle pin' })
vim.keymap.set('n', '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Delete non-pinned buffers' })
vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Delete other buffers' })

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '<leader>nh', '<cmd>noh<cr>', { desc = 'Clear highlights' })

vim.keymap.set('n', '<leader>wsh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wsv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wse', '<C-w>=', { desc = 'Make splits equal size' })
vim.keymap.set('n', '<leader>wx', '<cmd>close<cr>', { desc = 'Close window' })

vim.keymap.set('n', '<leader>fw', '<cmd>w<cr><esc>', { desc = '[F]ile [W]rite' })

vim.keymap.set('n', '<leader>dx', function()
  require('trouble').toggle()
end, { desc = 'Toggle trouble' })
vim.keymap.set('n', '<leader>dw', function()
  require('trouble').toggle('workspace_diagnostics')
end, { desc = 'Toggle workspace diagnostics' })
--vim.keymap.set('n', '<leader>dd', function() require('trouble').toggle('document_diagnostics') end, { desc = 'Toggle document diagnostics' })
vim.keymap.set('n', '<leader>dq', function()
  require('trouble').toggle('quickfix')
end, { desc = 'Toggle Quick Fix' })
vim.keymap.set('n', 'gR', function()
  require('trouble').toggle('lsp_references')
end, { desc = 'Toggle trouble' })

vim.api.nvim_set_keymap('n', '<leader>sc', '<cmd>lua require("switch_case").switch_case()<CR>',
  { noremap = true, silent = true })
