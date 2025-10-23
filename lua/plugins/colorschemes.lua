return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'storm',
        light_style = 'day',
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
        },
      })
      vim.cmd.colorscheme('tokyonight-storm')
    end,
  },
}
