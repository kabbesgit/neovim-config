local uv = vim.uv or vim.loop

local function normalize(path)
  if not path or path == '' then
    return nil
  end
  return vim.fs and vim.fs.normalize(path) or vim.fn.fnamemodify(path, ':p')
end

local function exists(path)
  local resolved = normalize(path)
  return resolved and uv.fs_stat(resolved) ~= nil
end

local function collect_glob(pattern)
  if not pattern or pattern == '' then
    return {}
  end
  local ok, result = pcall(vim.fn.glob, pattern, false, true)
  if not ok then
    return {}
  end
  if type(result) == 'table' then
    return result
  end
  if type(result) == 'string' and result ~= '' then
    return { result }
  end
  return {}
end

local function find_codelldb()
  local candidates = {}

  local function add(path)
    if path and path ~= '' then
      table.insert(candidates, vim.fn.expand(path))
    end
  end

  add(vim.g.xcodebuild_codelldb_path)
  add(os.getenv('CODELLDB_PATH'))

  local mason_base = vim.fn.stdpath('data') .. '/mason'
  add(mason_base .. '/bin/codelldb')
  add(mason_base .. '/packages/codelldb/extension/adapter/codelldb')

  for _, path in ipairs(collect_glob(vim.fn.expand('~/.vscode/extensions/vadimcn.vscode-lldb-*/adapter/codelldb'))) do
    add(path)
  end

  local code_insiders = vim.fn.expand('~/Library/Application Support/Code - Insiders/User/globalStorage/vadimcn.vscode-lldb/adapter/codelldb')
  add(code_insiders)
  add(vim.fn.expand('~/Library/Application Support/Code/User/globalStorage/vadimcn.vscode-lldb/adapter/codelldb'))

  for _, candidate in ipairs(candidates) do
    if exists(candidate) then
      return normalize(candidate)
    end
  end

  return nil
end

local function find_lldb()
  local candidates = {
    vim.g.xcodebuild_lldb_library,
    os.getenv('LLDB_LIBRARY_PATH'),
    '/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB',
    '/Applications/Xcode-beta.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB',
  }

  for _, candidate in ipairs(candidates) do
    if exists(candidate) then
      return normalize(candidate)
    end
  end

  return nil
end

return {
  'wojciech-kulik/xcodebuild.nvim',
  dependencies = {
    "MunifTanjim/nui.nvim",
    "stevearc/oil.nvim",
  },
  ft = { 'swift', 'objc' },
  config = function()
    local integrations = {
      pymobiledevice = {
        enabled = true,
        remote_debugger_port = 65123,
      },
    }

    local codelldb_path = find_codelldb()
    if codelldb_path then
      integrations.codelldb = {
        enabled = true,
        codelldb_path = codelldb_path,
        lldb_lib_path = find_lldb(),
      }
    elseif vim.g.xcodebuild_codelldb_path or os.getenv('CODELLDB_PATH') then
      vim.notify(
        'xcodebuild.nvim: could not resolve configured codelldb path, falling back to lldb-dap.',
        vim.log.levels.WARN
      )
    end

    require('xcodebuild').setup({
      code_coverage = {
        enabled = false,
      },
      integrations = integrations,
    })

    vim.keymap.set('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', { desc = 'Show Xcodebuild Actions' })
    vim.keymap.set('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Show Project Manager Actions' })

    vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = 'Build Project' })
    vim.keymap.set('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = 'Build For Testing' })
    vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Build & Run Project' })

    vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Run Tests' })
    vim.keymap.set('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Run Selected Tests' })
    vim.keymap.set('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Run Current Test Class' })
    vim.keymap.set('n', '<leader>x.', '<cmd>XcodebuildTestRepeat<cr>', { desc = 'Repeat Last Test Run' })

    vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Toggle Xcodebuild Logs' })
    vim.keymap.set('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Toggle Code Coverage' })
    vim.keymap.set('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = 'Show Code Coverage Report' })
    vim.keymap.set('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Toggle Test Explorer' })
    vim.keymap.set('n', '<leader>xs', '<cmd>XcodebuildFailingSnapshots<cr>', { desc = 'Show Failing Snapshots' })

    vim.keymap.set('n', '<leader>xp', '<cmd>XcodebuildPreviewGenerateAndShow<cr>', { desc = 'Generate Preview' })
    vim.keymap.set('n', '<leader>x<cr>', '<cmd>XcodebuildPreviewToggle<cr>', { desc = 'Toggle Preview' })

    vim.keymap.set('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Select Device' })
    vim.keymap.set('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', { desc = 'Show QuickFix List' })

    vim.keymap.set('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Quickfix Line' })
    vim.keymap.set('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Show Code Actions' })

    local wk = require('which-key')
    wk.add({
      { '<leader>x', group = 'xcode' },
    })
  end,
}
