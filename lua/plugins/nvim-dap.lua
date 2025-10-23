return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "wojciech-kulik/xcodebuild.nvim"
  },
  config = function()
    local uv = vim.uv or vim.loop

    local function normalize(path)
      if not path or path == "" then
        return nil
      end
      return vim.fs and vim.fs.normalize(path) or vim.fn.fnamemodify(path, ":p")
    end

    local function exists(path)
      local resolved = normalize(path)
      return resolved and uv.fs_stat(resolved) ~= nil
    end

    local function collect_glob(pattern)
      if not pattern or pattern == "" then
        return {}
      end
      local ok, result = pcall(vim.fn.glob, pattern, false, true)
      if not ok then
        return {}
      end
      if type(result) == "table" then
        return result
      end
      if type(result) == "string" and result ~= "" then
        return { result }
      end
      return {}
    end

    local function find_codelldb()
      local candidates = {}

      local function add(path)
        if path and path ~= "" then
          table.insert(candidates, vim.fn.expand(path))
        end
      end

      add(vim.g.xcodebuild_codelldb_path)
      add(os.getenv("CODELLDB_PATH"))

      local mason_base = vim.fn.stdpath("data") .. "/mason"
      add(mason_base .. "/bin/codelldb")
      add(mason_base .. "/packages/codelldb/extension/adapter/codelldb")

      for _, path in ipairs(collect_glob(vim.fn.expand("~/.vscode/extensions/vadimcn.vscode-lldb-*/adapter/codelldb"))) do
        add(path)
      end

      local code_insiders = vim.fn.expand("~/Library/Application Support/Code - Insiders/User/globalStorage/vadimcn.vscode-lldb/adapter/codelldb")
      add(code_insiders)
      add(vim.fn.expand("~/Library/Application Support/Code/User/globalStorage/vadimcn.vscode-lldb/adapter/codelldb"))

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
        os.getenv("LLDB_LIBRARY_PATH"),
        "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
        "/Applications/Xcode-beta.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
      }

      for _, candidate in ipairs(candidates) do
        if exists(candidate) then
          return normalize(candidate)
        end
      end

      return nil
    end

    local ok, xcodebuild = pcall(require, "xcodebuild.integrations.dap")
    if not ok then
      vim.notify("xcodebuild.nvim integration not available", vim.log.levels.ERROR)
      return
    end

    local codelldb_path = find_codelldb()
    local configured = false
    if not codelldb_path then
      vim.notify(
        "xcodebuild.nvim: Could not find codelldb adapter. Set vim.g.xcodebuild_codelldb_path or CODELLDB_PATH.",
        vim.log.levels.ERROR
      )
    else
      xcodebuild.setup(codelldb_path, nil, find_lldb())
      configured = true
    end

    local function with_setup(fn)
      return function(...)
        if not configured then
          if not codelldb_path then
            vim.notify(
              "xcodebuild.nvim: configure codelldb before starting the debugger (vim.g.xcodebuild_codelldb_path or CODELLDB_PATH).",
              vim.log.levels.ERROR
            )
            return
          end

          xcodebuild.setup(codelldb_path, nil, find_lldb())
          configured = true
        end

        return fn(...)
      end
    end

    vim.keymap.set("n", "<leader>dd", with_setup(xcodebuild.build_and_debug), { desc = "Build & Debug" })
    vim.keymap.set("n", "<leader>dg", with_setup(xcodebuild.debug_without_build), { desc = "Debug Without Building" })
    vim.keymap.set("n", "<leader>dy", with_setup(xcodebuild.debug_tests), { desc = "Debug Tests" })
    vim.keymap.set("n", "<leader>dY", with_setup(xcodebuild.debug_class_tests), { desc = "Debug Class Tests" })
    vim.keymap.set("n", "<leader>b", with_setup(xcodebuild.toggle_breakpoint), { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>B", with_setup(xcodebuild.toggle_message_breakpoint), { desc = "Toggle Message Breakpoint" })
    vim.keymap.set("n", "<leader>df", with_setup(xcodebuild.terminate_session), { desc = "Terminate Debugger" })
  end,
}
