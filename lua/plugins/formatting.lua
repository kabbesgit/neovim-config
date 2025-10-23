return {
  'stevearc/conform.nvim',
  events = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  lazy = false,
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = { '' },
      desc = 'Format buffer',
    },
  },
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      css = { 'prettierd' },
      json = { 'prettierd' },
      lua = { 'stylua' },
      swift = { 'swift' },
      yaml = { 'yamlfmt' },
      python = { 'ruff_format' },
    },
    format_on_save = function(bufNr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufNr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
  init = function()
    vim.api.nvim_create_user_command('ToggleAutoFormat', function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify(string.format('Auto format %s in buffer', vim.b.disable_autoformat and 'disabled' or 'enabled'), 'info', { title = 'Conform' })
      else
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify(string.format('Auto format %s globally', vim.g.disable_autoformat and 'disabled' or 'enabled'), 'info', { title = 'Conform' })
      end
    end, {
      desc = 'Toggle autoformat-on-save',
      bang = true,
    })
    vim.keymap.set('n', '<leader>tf', ':ToggleAutoFormat!<CR>', { desc = 'Toggle auto format in buffer', noremap = true, silent = true })
  end,
}
