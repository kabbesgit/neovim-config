return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        'folke/tokyonight.nvim',
        lazy = false,
        config = function()
          require('tokyonight').setup({
            style = 'night',
            light_style = 'day',
            transparent = false,
          })
        end,
      },
    },
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false,
      })

      local function apply_scheme(background)
        local scheme = background == 'light' and 'tokyonight-day' or 'catppuccin'
        local ok, err = pcall(vim.cmd.colorscheme, scheme)
        if not ok then
          vim.notify(('Failed to load colorscheme %s: %s'):format(scheme, err), vim.log.levels.ERROR)
        end
      end

      apply_scheme(vim.o.background)

      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'background',
        callback = function()
          apply_scheme(vim.o.background)
        end,
      })
    end,
  },
}
