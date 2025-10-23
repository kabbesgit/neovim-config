return {
  {
    'mfussenegger/nvim-dap',
  },
  { 'nvim-neotest/nvim-nio' },
  {
    'theHamsta/nvim-dap-virtual-text',
  },
  {
    'rcarriga/nvim-dap-ui',
    config = function()
      require('dapui').setup()
    end,
  },
}
