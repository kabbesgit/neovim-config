return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'rust_analyzer', 'ts_ls', 'lua_ls', 'biome', 'ruff' },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'nvim-dap-ui' }
    },
    config = function()
      local ok_blink, blink = pcall(require, 'blink.cmp')
      local base_capabilities = ok_blink and blink.get_lsp_capabilities() or nil
      local lspconfig = require('lspconfig')

      local function build_opts(opts)
        opts = opts or {}
        if base_capabilities then
          opts.capabilities = vim.tbl_deep_extend('force', {}, base_capabilities, opts.capabilities or {})
        end
        return opts
      end

      local function configure(server, opts)
        opts = build_opts(opts)
        if not lspconfig[server] then
          vim.notify(string.format('LSP config for %s not found', server), vim.log.levels.WARN)
          return
        end
        lspconfig[server].setup(opts)
      end

      local util = require('lspconfig.util')

      configure('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim', 'Snacks' },
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      })

      configure('ts_ls', {
        settings = {
          diagnostics = { ignoredCodes = { 2686, 6133, 80006 } },
          completions = {
            completeFunctionCalls = true,
          },
        },
      })

      configure('sourcekit', {
        cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
        root_dir = function(filename, _)
          local path = filename
          if type(path) == 'number' then
            path = vim.api.nvim_buf_get_name(path)
          end
          if not path or path == '' then
            path = vim.api.nvim_buf_get_name(0)
          end
          if path and path ~= '' then
            path = vim.fs.normalize(path)
          end

          local git_dir = path and vim.fs.find('.git', { path = path, upward = true })[1] or nil

          local root = util.root_pattern('Package.swift')(path)
              or util.root_pattern('buildServer.json')(path)
              or util.root_pattern('*.xcodeproj', '*.xcworkspace')(path)
              or (git_dir and vim.fs.dirname(git_dir))
              or vim.uv.cwd()

          return root
        end,
      })

      configure('biome')
      configure('pyright')

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufnr = ev.buf

          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end

          nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode Rename')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode Action')
          nmap('gd', vim.lsp.buf.definition, 'Goto Definition')

          local function toggle_inlay_hints()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
          end
          nmap('<leader>cth', toggle_inlay_hints, 'Toggle inlay hints')
        end,
      })
    end,
  },
}
