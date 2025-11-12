return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    compile = false,
    dimInactive = true,
  },
  config = function(_, opts)
    local kanagawa = require('kanagawa')
    kanagawa.setup(opts)

    local function apply_scheme(background)
      local scheme = background == 'light' and 'kanagawa-lotus' or 'kanagawa-wave'
      vim.cmd.colorscheme(scheme)
    end

    apply_scheme(vim.o.background)

    vim.api.nvim_create_autocmd('OptionSet', {
      pattern = 'background',
      callback = function()
        apply_scheme(vim.o.background)
      end,
    })
  end,
}
