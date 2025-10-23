return {
  'rcarriga/nvim-dap-ui',
  event = { 'BufReadPost', 'BufNewFile' },
  init = function()
    local function lazy_load(...)
      local plugins = { ... }
      local ok, lazy = pcall(require, 'lazy')
      if not ok then
        return false
      end
      lazy.load({ plugins = plugins })
      return true
    end

    local function with_dap(callback)
      return function(...)
        lazy_load('nvim-dap', 'nvim-dap-ui')
        local ok, dap = pcall(require, 'dap')
        if not ok then
          vim.notify('nvim-dap is not available', vim.log.levels.ERROR)
          return
        end
        return callback(dap, ...)
      end
    end

    local function with_dapui(callback)
      return function(...)
        lazy_load('nvim-dap', 'nvim-dap-ui')
        local ok, dapui = pcall(require, 'dapui')
        if not ok then
          vim.notify('nvim-dap-ui is not available', vim.log.levels.ERROR)
          return
        end
        return callback(dapui, ...)
      end
    end

    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc })
    end

    map('<leader>db', with_dap(function(dap)
      dap.toggle_breakpoint()
    end), 'Toggle breakpoint')

    map('<leader>dB', with_dap(function(dap)
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end), 'Conditional breakpoint')

    map('<leader>dc', with_dap(function(dap)
      dap.continue()
    end), 'Continue')

    map('<leader>dC', with_dap(function(dap)
      dap.run_to_cursor()
    end), 'Run to cursor')

    map('<leader>ds', with_dap(function(dap)
      dap.step_over()
    end), 'Step over')

    map('<leader>di', with_dap(function(dap)
      dap.step_into()
    end), 'Step into')

    map('<leader>do', with_dap(function(dap)
      dap.step_out()
    end), 'Step out')

    map('<leader>dr', with_dap(function(dap)
      if dap.restart then
        dap.restart()
      else
        dap.terminate()
        dap.continue()
      end
    end), 'Restart')

    map('<leader>dt', with_dap(function(dap)
      dap.terminate()
    end), 'Terminate')

    map('<leader>du', with_dapui(function(dapui)
      dapui.toggle()
    end), 'Toggle DAP UI')

    map('<leader>de', with_dapui(function(dapui)
      dapui.eval()
    end), 'Evaluate expression')
    map('<leader>de', with_dapui(function(dapui)
      dapui.eval()
    end), 'Evaluate selection', 'v')

    map('<leader>dv', function()
      lazy_load('nvim-dap', 'nvim-dap-ui', 'nvim-dap-virtual-text')
      vim.cmd('DapVirtualTextToggle')
    end, 'Toggle DAP virtual text')

    map('<F5>', with_dap(function(dap)
      dap.continue()
    end), 'Continue/Start debugging')

    map('<F9>', with_dap(function(dap)
      dap.toggle_breakpoint()
    end), 'Toggle breakpoint')

    map('<F10>', with_dap(function(dap)
      dap.step_over()
    end), 'Step over')

    map('<F11>', with_dap(function(dap)
      dap.step_into()
    end), 'Step into')

    map('<S-F11>', with_dap(function(dap)
      dap.step_out()
    end), 'Step out')

    map('<S-F5>', with_dap(function(dap)
      if dap.restart then
        dap.restart()
      else
        dap.terminate()
        dap.continue()
      end
    end), 'Restart debugging')

    map('<C-F5>', with_dap(function(dap)
      dap.terminate()
    end), 'Stop debugging')
  end,
  dependencies = {
    'mfussenegger/nvim-dap',
    'theHamsta/nvim-dap-virtual-text',
    'leoluz/nvim-dap-go',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- Setup DAP UI
    dapui.setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = ""
        }
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" }
        }
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
      },
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 }
          },
          position = "left",
          size = 40
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 }
          },
          position = "bottom",
          size = 10
        }
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
      },
      render = {
        indent = 1,
        max_value_lines = 100
      }
    })

    -- UPDATED: Virtual text with improved configuration
    dap_virtual_text.setup({
      enabled = true, -- CHANGED: Now enabled by default with limits
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,

      -- IMPROVED: Custom display callback to limit length
      display_callback = function(variable, buf, stackframe, node, options)
        -- Limit value length to prevent clutter
        local value = variable.value
        if #value > 50 then
          value = string.sub(value, 1, 50) .. '...'
        end

        if options.virt_text_pos == 'inline' then
          return ' = ' .. value
        else
          return variable.name .. ' = ' .. value
        end
      end,

      virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil
    })

    -- Setup Go debugging
    require("dap-go").setup({
      delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {},
        build_flags = "",
        detached = vim.fn.has("win32") == 0,
        cwd = nil,
      },
    })

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Go-specific debugging keymaps
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("GoDebugMappings", { clear = true }),
      pattern = "go",
      callback = function(event)
        vim.keymap.set("n", "<leader>td", function()
          require("dap-go").debug_test()
        end, { buffer = event.buf, desc = "Debug test" })

        vim.keymap.set("n", "<leader>tD", function()
          require("dap-go").debug_last_test()
        end, { buffer = event.buf, desc = "Debug last test" })
      end,
    })

    -- DAP signs
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition",
      { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "🟢", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "🔶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

    local function set_dap_highlights()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#0f255c", fg = "NONE" })
    end

    set_dap_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("DapHighlights", { clear = true }),
      callback = set_dap_highlights,
    })
  end,
}
