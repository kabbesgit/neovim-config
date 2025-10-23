local diagnosticsIcons = {
  error = ' ',
  warn = ' ',
  info = ' ',
  hint = ' ',
}

local function xcodebuild_device()
  if vim.g.xcodebuild_platform == 'macOS' then
    return ' macOS'
  end

  local deviceIcon = ''
  if vim.g.xcodebuild_platform:match('watch') then
    deviceIcon = '􀟤'
  elseif vim.g.xcodebuild_platform:match('tv') then
    deviceIcon = '􀡴 '
  elseif vim.g.xcodebuild_platform:match('vision') then
    deviceIcon = '􁎖 '
  end

  if vim.g.xcodebuild_os then
    return deviceIcon .. ' ' .. vim.g.xcodebuild_device_name .. ' (' .. vim.g.xcodebuild_os .. ')'
  end

  return deviceIcon .. ' ' .. vim.g.xcodebuild_device_name
end

return {
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            'diagnostics',
            symbols = diagnosticsIcons,
          },
          {
            'filetype',
            icon_only = true,
            separator = '',
            padding = {
              left = 1,
              right = 0,
            },
          },
          { 'filename', path = 1, symbols = { modified = '  ', readonly = '', unnamed = '' } },
        },
        lualine_x = {
          { "' ' .. vim.g.xcodebuild_last_status" },
          { "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = '#a6e3a1', bg = '#161622' } },
          { xcodebuild_device },
          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
          },
        },
        lualine_y = {
          {
            'progress',
            separator = ' ',
            padding = { left = 1, right = 0 },
          },
          { 'location', padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return ' ' .. os.date('%R')
          end,
        },
      },
      extensions = { 'neo-tree', 'lazy' },
    },
  },
  {
    'christoomey/vim-tmux-navigator',
  },
  {
    'folke/which-key.nvim',
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.add({
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code' },
        { '<leader>d', group = 'diagnostics' },
        { '<leader>f', group = 'file/find' },
        { '<leader>g', group = 'git' },
        { '<leader>h', group = 'hunks' },
        { '<leader>q', group = 'quit/session' },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'test' },
        { '<leader>w', group = 'workspace' },
      })
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and diagnosticsIcons.error .. diag.error .. ' ' or '') ..
              (diag.warning and diagnosticsIcons.warn .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
  },
  { 'echasnovski/mini.icons', version = false },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')

      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      vim.keymap.set('n', '<C-1>', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<C-2>', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<C-3>', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<C-4>', function() harpoon:list():select(4) end)
      for index = 1, 8 do
        vim.keymap.set('n', string.format('<leader>%d', index), function()
          harpoon:list():select(index)
        end, { desc = string.format('Harpoon to slot %d', index) })
      end

      vim.keymap.set('n', '<leader>fa', function() harpoon:list():prev() end)
      vim.keymap.set('n', '<leader>af', function() harpoon:list():next() end)
      vim.keymap.set('n', '<leader>ch', function()
        local list = harpoon:list()
        list:clear()
        harpoon:sync()
      end, { desc = 'Clear Harpoon Marks' })
    end,
  },
}
