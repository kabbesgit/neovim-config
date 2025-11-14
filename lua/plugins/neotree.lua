return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    local function get_safe_dir()
      local dir = vim.loop.cwd()
      if dir and dir ~= '' and vim.loop.fs_stat(dir) then
        return dir
      end

      local ok, fallback = pcall(vim.fn.getcwd)
      if ok and fallback ~= '' and vim.loop.fs_stat(fallback) then
        return fallback
      end

      return vim.loop.os_homedir()
    end

    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end
    local events = require('neo-tree.events')
    local opts = {
      enable_diagnostics = true,
      event_handlers = {
        { event = events.FILE_MOVED,   handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        diagnostics = {
          symbols = {
            hint = '',
            info = ' ',
            warn = ' ',
            error = ' ',
          },
          highlights = {
            hint = 'DiagnosticSignHint',
            info = 'DiagnosticSignInfo',
            warn = 'DiagnosticSignWarn',
            error = 'DiagnosticSignError',
          },
        },
      },
      window = {
        width = 48,           -- pick your preferred column width
        auto_expand_width = false,
        persist_width = true, -- remember the width between toggles.
      },
    }
    local nt = require('neo-tree')
    nt.setup(opts)
    vim.g.neo_tree_remove_legacy_commands = 1

    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
        require('neo-tree')
      end
    end

    -- Toggle file browser
    vim.keymap.set('n', '<leader>e', function()
      require('neo-tree.command').execute({ toggle = true, dir = get_safe_dir() })
    end, { desc = 'Toggle file explorer' })
  end,
}
