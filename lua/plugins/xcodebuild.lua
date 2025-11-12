local codelldb = require('swifty.codelldb')

return {
  'wojciech-kulik/xcodebuild.nvim',
  dependencies = {
    "MunifTanjim/nui.nvim",
    "stevearc/oil.nvim",
  },
  ft = { 'swift', 'objc' },
  config = function()
    local integrations = {
      pymobiledevice = {
        enabled = true,
        remote_debugger_port = 65123,
      },
    }

    local codelldb_path = codelldb.find_codelldb()
    if codelldb_path then
      integrations.codelldb = {
        enabled = true,
        codelldb_path = codelldb_path,
        lldb_lib_path = codelldb.find_lldb(),
      }
    elseif vim.g.xcodebuild_codelldb_path or os.getenv('CODELLDB_PATH') then
      vim.notify(
        'xcodebuild.nvim: could not resolve configured codelldb path, falling back to lldb-dap.',
        vim.log.levels.WARN
      )
    end

    require('xcodebuild').setup({
      code_coverage = {
        enabled = false,
      },
      integrations = integrations,
    })

    vim.keymap.set('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', { desc = 'Show Xcodebuild Actions' })
    vim.keymap.set('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Show Project Manager Actions' })

    vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = 'Build Project' })
    vim.keymap.set('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = 'Build For Testing' })
    vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Build & Run Project' })

    vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Run Tests' })
    vim.keymap.set('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Run Selected Tests' })
    vim.keymap.set('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Run Current Test Class' })
    vim.keymap.set('n', '<leader>x.', '<cmd>XcodebuildTestRepeat<cr>', { desc = 'Repeat Last Test Run' })

    vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Toggle Xcodebuild Logs' })
    vim.keymap.set('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Toggle Code Coverage' })
    vim.keymap.set('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = 'Show Code Coverage Report' })
    vim.keymap.set('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Toggle Test Explorer' })
    vim.keymap.set('n', '<leader>xs', '<cmd>XcodebuildFailingSnapshots<cr>', { desc = 'Show Failing Snapshots' })

    vim.keymap.set('n', '<leader>xp', '<cmd>XcodebuildPreviewGenerateAndShow<cr>', { desc = 'Generate Preview' })
    vim.keymap.set('n', '<leader>x<cr>', '<cmd>XcodebuildPreviewToggle<cr>', { desc = 'Toggle Preview' })

    vim.keymap.set('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Select Device' })
    vim.keymap.set('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', { desc = 'Show QuickFix List' })

    vim.keymap.set('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Quickfix Line' })
    vim.keymap.set('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Show Code Actions' })

    local wk = require('which-key')
    wk.add({
      { '<leader>x', group = 'xcode' },
    })
  end,
}
