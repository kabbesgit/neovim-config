return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "wojciech-kulik/xcodebuild.nvim"
  },
  config = function()
    local ok, xcodebuild = pcall(require, 'xcodebuild.integrations.dap')
    if not ok then
      vim.notify('xcodebuild.nvim integration not available', vim.log.levels.ERROR)
      return
    end

    xcodebuild.setup()

    vim.keymap.set('n', '<leader>dd', xcodebuild.build_and_debug, { desc = 'Build & Debug' })
    vim.keymap.set('n', '<leader>dg', xcodebuild.debug_without_build, { desc = 'Debug Without Building' })
    vim.keymap.set('n', '<leader>dy', xcodebuild.debug_tests, { desc = 'Debug Tests' })
    vim.keymap.set('n', '<leader>dY', xcodebuild.debug_class_tests, { desc = 'Debug Class Tests' })
    vim.keymap.set('n', '<leader>b', xcodebuild.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', xcodebuild.toggle_message_breakpoint, { desc = 'Toggle Message Breakpoint' })
    vim.keymap.set('n', '<leader>df', xcodebuild.terminate_session, { desc = 'Terminate Debugger' })
  end,
}
