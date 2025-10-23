return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    dependencies = { 'davidmh/cspell.nvim' },
    opts = function(_, opts)
      local cspell = require('cspell')
      local cspell_config = {
        config_file_preferred_name = '.cspell.json',
        cspell_config_dirs = { '~/.config/' },
      }
      opts.sources = opts.sources or {}
      table.insert(
        opts.sources,
        cspell.diagnostics.with({
          config = cspell_config,
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.HINT
          end,
        })
      )
      table.insert(opts.sources, cspell.code_actions.with({ config = cspell_config }))
    end,
  },
}
