local uv = vim.uv or vim.loop

local M = {}

local function normalize(path)
  if not path or path == '' then
    return nil
  end
  return (vim.fs and vim.fs.normalize(path)) or vim.fn.fnamemodify(path, ':p')
end

local DEFAULT_LLDB = '/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB'

local function exists(path)
  local resolved = normalize(path)
  return resolved and uv.fs_stat(resolved) ~= nil
end

local function default_port()
  return 13000
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

function M.find_codelldb()
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

function M.find_lldb()
  local candidates = {
    vim.g.xcodebuild_lldb_library,
    os.getenv('LLDB_LIBRARY_PATH'),
    '/Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Versions/A/LLDB',
    DEFAULT_LLDB,
    '/Applications/Xcode-beta.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB',
  }

  for _, candidate in ipairs(candidates) do
    if exists(candidate) then
      return normalize(candidate)
    end
  end

  return nil
end

function M.pick_free_port(fallback)
  local tcp = uv.new_tcp()
  if not tcp then
    return fallback or default_port()
  end

  local ok = pcall(tcp.bind, tcp, '127.0.0.1', 0)
  if not ok then
    tcp:close()
    return fallback or default_port()
  end

  local address = tcp:getsockname()
  tcp:close()

  if address and address.port then
    return address.port
  end

  return fallback or default_port()
end

function M.build_adapter(codelldb_path, lldb_path, port)
  local resolved_lldb = lldb_path or M.find_lldb() or DEFAULT_LLDB
  local resolved_port = tostring(port or default_port())

  return {
    type = 'server',
    port = resolved_port,
    executable = {
      command = codelldb_path,
      args = {
        '--port',
        resolved_port,
        '--liblldb',
        resolved_lldb,
      },
    },
  }
end

return M
