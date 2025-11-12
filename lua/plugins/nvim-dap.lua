local codelldb = require('swifty.codelldb')

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

    local ok_setup, err = pcall(xcodebuild.setup)
    if not ok_setup then
      vim.notify(string.format('xcodebuild.nvim: failed to configure debugger (%s)', err), vim.log.levels.ERROR)
      return
    end

    local codelldb_path = codelldb.find_codelldb()
    if codelldb_path then
      local lldb_path = codelldb.find_lldb()
      local dap = require('dap')
      dap.adapters.codelldb = function(callback)
        local port = codelldb.pick_free_port()
        callback(codelldb.build_adapter(codelldb_path, lldb_path, port))
      end
    end

    vim.keymap.set('n', '<leader>dd', xcodebuild.build_and_debug, { desc = 'Build & Debug' })
    vim.keymap.set('n', '<leader>dg', xcodebuild.debug_without_build, { desc = 'Debug Without Building' })
    vim.keymap.set('n', '<leader>dy', xcodebuild.debug_tests, { desc = 'Debug Tests' })
    vim.keymap.set('n', '<leader>dY', xcodebuild.debug_class_tests, { desc = 'Debug Class Tests' })
    vim.keymap.set('n', '<leader>b', xcodebuild.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', xcodebuild.toggle_message_breakpoint, { desc = 'Toggle Message Breakpoint' })
    vim.keymap.set('n', '<leader>df', xcodebuild.terminate_session, { desc = 'Terminate Debugger' })
  end,
}
