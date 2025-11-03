return {
  "walkersumida/fusen.nvim",
  opts = {
    -- Storage location
    save_file = vim.fn.expand("$HOME") .. "/fusen_marks.json",

    -- Mark appearance
    mark = {
      icon = "📌",
      hl_group = "FusenMark",
    },

    -- Key mappings
    keymaps = {
      add_mark = "me",     -- Add/edit sticky note
      clear_mark = "mc",   -- Clear mark at current line
      clear_buffer = "mC", -- Clear all marks in buffer
      clear_all = "mD",    -- Clear ALL marks (deletes entire JSON content)
      next_mark = "mn",    -- Jump to next mark
      prev_mark = "mp",    -- Jump to previous mark
      list_marks = "ml",   -- Show marks in quickfix
    },

    -- Telescope integration settings
    telescope = {
      keymaps = {
        delete_mark_insert = "<C-d>", -- Delete mark in insert mode
        delete_mark_normal = "<C-d>", -- Delete mark in normal mode
      },
    },

    -- Sign column priority
    sign_priority = 10,

    -- Annotation display settings
    annotation_display = {
      mode = "float", -- "eol", "float", "both", "none"
      spacing = 2,    -- Number of spaces before annotation in eol mode

      -- Float window settings
      float = {
        delay = 300,       -- Show after 300ms (default: 100ms)
        border = "single", -- Border style: "single", "double", "rounded", etc
        max_width = 60,    -- Maximum width (defUlt: 50)
        max_height = 15,   -- Maximum height (default: 10)
      },
    },

    -- Exclude specific filetypes from keymaps
    exclude_filetypes = {
      -- "neo-tree",     -- Example: neo-tree
      -- "NvimTree",     -- Example: nvim-tree
      -- "nerdtree",     -- Example: NERDTree
    },
  }
}
