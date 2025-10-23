return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      -- {
      --   'nvim-telescope/telescope-fzf-native.nvim',
      --   build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      -- },
    },
    -- config = function()
    --   local builtin = require('telescope.builtin')
    --   vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles (Root)' })
    --   vim.keymap.set('n', '<leader>sF', function()
    --     local package_dir = vim.lsp.get_active_clients()[1].config.root_dir
    --     builtin.find_files({ cwd = package_dir })
    --   end, { desc = '[S]earch [F]iles (Package)' })
    --   vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    --   vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    --   vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep (Root)' })
    --   vim.keymap.set('n', '<leader>sG', function()
    --     local package_dir = vim.lsp.get_active_clients()[1].config.root_dir
    --     builtin.live_grep({ cwd = package_dir })
    --   end, { desc = '[S]earch by [G]rep (Package)' })
    --   vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({
              -- even more opts
            }),
          },
          -- fzf = {
          --   fuzzy = true, -- false will only do exact matching
          --   override_generic_sorter = true, -- override the generic sorter
          --   override_file_sorter = true, -- override the file sorter
          --   case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          --   -- the default case_mode is "smart_case"
          -- },
        },
      })
      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('ui-select')
      -- require('telescope').load_extension('fzf')
    end,
  },
}
