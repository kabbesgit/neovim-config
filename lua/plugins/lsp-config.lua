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

      local function build_opts(opts)
        opts = opts or {}
        if base_capabilities then
          opts.capabilities = vim.tbl_deep_extend('force', {}, base_capabilities, opts.capabilities or {})
        end
        return opts
      end

      local function configure(server, opts)
        local ok, err = pcall(vim.lsp.config, server, build_opts(opts))
        if not ok then
          vim.notify(string.format('Failed to configure %s: %s', server, err), vim.log.levels.ERROR)
          return
        end
        vim.lsp.enable(server)
      end

      local util = require('lspconfig.util')
      local ms = vim.lsp.protocol.Methods

      local function ensure_sourcekit_capabilities(client)
        if not client or client.name ~= 'sourcekit' then
          return
        end
        local caps = client.server_capabilities or {}
        caps.definitionProvider = true
        caps.referencesProvider = true
        caps.implementationProvider = true
        caps.typeDefinitionProvider = true
        caps.documentSymbolProvider = true
        caps.workspaceSymbolProvider = true
        caps.callHierarchyProvider = true
        caps.documentHighlightProvider = true
        caps.declarationProvider = true
        caps.linkedEditingRangeProvider = true
        client.server_capabilities = caps

        if not client._swifty_supports_method_wrapped then
          local forced = {
            [ms.textDocument_definition] = true,
            [ms.textDocument_references] = true,
            [ms.textDocument_implementation] = true,
            [ms.textDocument_typeDefinition] = true,
            [ms.textDocument_documentSymbol] = true,
            [ms.workspace_symbol] = true,
            [ms.textDocument_documentHighlight] = true,
            [ms.textDocument_declaration] = true,
          }
          local original = client.supports_method
          client.supports_method = function(self, method, ...)
            if forced[method] then
              return true
            end
            return original(self, method, ...)
          end
          client._swifty_supports_method_wrapped = true
        end
      end

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

      local function find_xcode_host_dir(start_path)
        if not start_path or start_path == '' then
          return nil
        end

        local match = vim.fs.find(function(name, path)
          if name:match('%.xcodeproj$') or name:match('%.xcworkspace$') then
            return true
          end
          return false
        end, { path = start_path, upward = true, limit = 1 })[1]

        return match and vim.fs.dirname(match) or nil
      end

      configure('sourcekit', {
        cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
        filetypes = { 'swift', 'objc', 'objcpp' },
        root_dir = function(bufnr, on_dir)
          local path = bufnr
          if type(path) == 'number' then
            path = vim.api.nvim_buf_get_name(path)
          end
          if not path or path == '' then
            path = vim.api.nvim_buf_get_name(0)
          end
          if not path or path == '' then
            on_dir(vim.uv.cwd())
            return
          end

          path = vim.fs.normalize(path)
          local root = util.root_pattern('Package.swift', 'buildServer.json')(path)
            or find_xcode_host_dir(path)

          if not root then
            local git_match = vim.fs.find('.git', { path = path, upward = true, limit = 1 })[1]
            if git_match then
              root = vim.fs.dirname(git_match)
            end
          end

          if not root or not vim.loop.fs_stat(root) then
            local parent = vim.fs.dirname(path)
            if parent and parent ~= '' and vim.loop.fs_stat(parent) then
              root = parent
            else
              root = vim.uv.cwd()
            end
          end

          on_dir(root)
        end,
        on_attach = ensure_sourcekit_capabilities,
      })

      configure('biome')
      configure('pyright')

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          ensure_sourcekit_capabilities(client)

          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end

          nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode Rename')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode Action')
          local function goto_definition()
            vim.api.nvim_create_autocmd('CursorMoved', {
              once = true,
              callback = function()
                pcall(vim.cmd, 'normal! zz')
              end,
            })
            vim.lsp.buf.definition()
          end

          nmap('gd', goto_definition, 'Goto Definition')
          nmap('<leader>gd', goto_definition, 'Goto Definition')

          local function toggle_inlay_hints()
            local enabled = vim.lsp.inlay_hint.is_enabled(bufnr)
            vim.lsp.inlay_hint.enable(bufnr, not enabled)
          end
          nmap('<leader>cth', toggle_inlay_hints, 'Toggle inlay hints')
        end,
      })
    end,
  },
}
