-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-a>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-M-]>",
        },
      })
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)

      vim.keymap.set("n", "<leader>cj", function()
        vim.cmd.GoTagAdd("json")
      end, { noremap = true, silent = true, desc = "GoTagAdd json" })
      vim.keymap.set("n", "<leader>cy", function()
        vim.cmd.GoTagAdd("yaml")
      end, { noremap = true, silent = true, desc = "GoTagAdd yaml" })
      vim.keymap.set("n", "<leader>ce", function()
        vim.cmd.GoIfErr()
      end, { noremap = true, silent = true, desc = "GoErr" })
      vim.keymap.set("n", "<leader>ct", function()
        vim.cmd.GoMod("tidy")
      end, { noremap = true, silent = true, desc = "GoModTidy" })
      vim.keymap.set("n", "<leader>cc", function()
        vim.cmd.GoCmt()
      end, { noremap = true, silent = true, desc = "GoDocComment" })
      vim.keymap.set("n", "<leader>dt", function()
        vim.cmd.GoTestAdd()
      end, { noremap = true, silent = true, desc = "Add Go Test for current function" })
    end,
    build = function()
      vim.cmd([[silent! GoInstallDeps]])
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()

      -- add keymap to toggle Dap UI
      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle()
      end, { noremap = true, silent = true, desc = "DAP UI Toggle" })

      -- close Dap UI with :DapCloseUI
      vim.api.nvim_create_user_command("DapCloseUI", function()
        require("dapui").close()
      end, {})
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { "/home/caiogallo/projects/vscode-php-debug/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
      }

      -- open Dap UI automatically when debug starts (e.g. after <F5>)
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      vim.keymap.set("n", "<leader>dc", function()
        require("dap").continue()
      end, { noremap = true, silent = true, desc = "DAP Continue" })
      vim.keymap.set("n", "<leader>do", function()
        require("dap").step_over()
      end, { noremap = true, silent = true, desc = "Step Over" })
      vim.keymap.set("n", "<leader>di", function()
        require("dap").step_into()
      end, { noremap = true, silent = true, desc = "Step Into" })
      vim.keymap.set("n", "<leader>dq", function()
        require("dap").step_out()
      end, { noremap = true, silent = true, desc = "Step Out" })
      vim.keymap.set("n", "<leader>db", function()
        require("dap").toggle_breakpoint()
      end, { noremap = true, silent = true, desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dd", function()
        require("dap").disconnect()
      end, { noremap = true, silent = true, desc = "Disconnect" })
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function(_, opts)
      require("dap-go").setup(opts)

      vim.keymap.set("n", "<leader>dgt", function()
        require("dap-go").debug_test()
      end, { noremap = true, silent = true, desc = "Debug go test" })

      vim.keymap.set("n", "<leader>dgl", function()
        require("dap-go").debug_last()
      end, { noremap = true, silent = true, desc = "Debug last go test" })
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you still want to use netrw.
      default_file_explorer = true,
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        "icon",
        "permissions",
        "size",
        -- "mtime",
      },
      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      delete_to_trash = false,
      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = false,
      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      -- (:help prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = true,
      -- Oil will automatically delete hidden buffers after this delay
      -- You can set the delay to false to disable cleanup entirely
      -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },
      -- Constrain the cursor to the editable parts of the oil buffer
      -- Set to `false` to disable, or "name" to keep it on the file names
      constrain_cursor = "editable",
      -- Set to true to watch the filesystem for changes and reload oil
      experimental_watch_for_changes = false,
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      -- Configuration for the floating keymaps help window
      keymaps_help = {
        border = "rounded",
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
        -- Sort file names in a more intuitive order for humans. Is less performant,
        -- so you may want to set to false if you work with large directories.
        natural_order = true,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      },
      -- EXPERIMENTAL support for performing file operations with git
      git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path)
          return false
        end,
        mv = function(src_path, dest_path)
          return false
        end,
        rm = function(path)
          return false
        end,
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
      -- Configuration for the actions floating preview window
      preview = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
        max_width = 0.9,
        -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
        max_height = 0.9,
        -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
      },
      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },
      -- Configuration for the floating SSH window
      ssh = {
        border = "rounded",
      },
    },
  },
  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    config = true,
    keys = {
      { '"', mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    name = "registers",
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufEnter",
    command = "Hardtime",
    config = function()
      require("hardtime").setup({
        disable_mouse = false,
        disabled_filetypes = {
          "qf",
          "netrw",
          "NvimTree",
          "lazy",
          "mason",
          "oil",
          "minifiles",
          "NeogitStatus",
          "copilot-chat",
          "dapui_scopes",
        },
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      lazygit = { enabled = true },
      rename = { enabled = true },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = {
        timeout = 3000, -- default timeout in ms
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        -- editor margin to keep free. tabline and statusline are taken into account automatically
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true, -- add 1 cell of left/right padding to the notification window
        sort = { "level", "added" }, -- sort by level and time
        -- minimum log level to display. TRACE is the lowest
        -- all notifications are stored in history
        level = vim.log.levels.TRACE,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        keep = function(notif)
          return vim.fn.getcmdpos() > 0
        end,
        ---@type snacks.notifier.style
        style = "compact",
        top_down = true, -- place notifications from top to bottom
        date_format = "%R", -- time format for notifications
        -- format for footer when more lines are available
        -- `%d` is replaced with the number of lines.
        -- only works for styles with a border
        ---@type string|boolean
        more_format = " ↓ %d lines ",
        refresh = 50, -- refresh at most every 50ms
      },
      quickfile = { enabled = true },
      scratch = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      zen = { enabled = false },
    },
    keys = {
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>nd",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "copilot-chat" },
      })
    end,
  },
  {
    "tjdevries/present.nvim",
    event = "VeryLazy",
  },
  -- {
  --   "saghen/blink.cmp",
  --   dependencies = "rafamadriz/friendly-snippets",
  --
  --   version = "*",
  --   opts = {
  --     keymap = { preset = "default" },
  --
  --     appearance = {
  --       use_nvim_cmp_as_default = true,
  --       nerd_font_variant = "mono",
  --     },
  --
  --     signature = { enabled = true },
  --     sources = {
  --       default = { "lsp", "path", "snippets", "buffer" },
  --       providers = {},
  --     },
  --     fuzzy = { implementation = "prefer_rust_with_warning" },
  --   },
  --   opts_extend = { "sources.default" },
  -- },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        -- config
        theme = "hyper",
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = "Telescope find_files",
              key = "f",
            },
            {
              desc = " Apps",
              group = "DiagnosticHint",
              action = "Telescope app",
              key = "a",
            },
            {
              desc = " dotfiles",
              group = "Number",
              action = "Telescope dotfiles",
              key = "d",
            },
          },
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  {
    "mbbill/undotree", -- Undo tree visualizer
    cmd = "UndotreeToggle",
    setup = function()
      vim.g.undotree_WindowLayout = 2
    end,
  },
  {
    "folke/flash.nvim",
    opts = {},
	 -- stylua: ignore
	 keys = {
	   { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
	   { "<leader>F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
	   { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
	   { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
	   { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	 },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    init = function()
      vim.opt.termguicolors = true
      require("bufferline").setup({
        options = {
          numbers = "none",
          mappings = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          ---@diagnostic disable-next-line: unused-local
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or " ")
              s = s .. n .. sym
            end
            return s
          end,
        },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
  },
  -- {
  --   "OmniSharp/omnisharp-vim", -- OmniSharp plugin
  --   init = function()
  --     vim.g.OmniSharp_server_stdio = 1
  --     vim.g.OmniSharp_server_use_net6 = 1
  --   end,
  -- },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "ThePrimeagen/harpoon",

    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      local harpoon = require("harpoon")
      harpoon:setup({})
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "NeogitOrg/neogit",
    tag = "v0.0.1",
    dependencies = {

      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "main",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   opts = {
  --     debug = false, -- Enable debugging
  --     context = "buffers",
  --   },
  --   keys = {
  --     {
  --       "<leader>gb",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  --         end
  --       end,
  --       desc = "CopilotChat - Quick chat",
  --     },
  --     {
  --       "<leader>gV",
  --       mode = "v",
  --       function()
  --         local input = vim.fn.input("Quick Chat from selection: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
  --         end
  --       end,
  --       desc = "CopilotChat - Quick chat from selection",
  --     },
  --     {
  --       "<leader>ga",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
  --       end,
  --       desc = "CopilotChat - Prompt actions",
  --     },
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  --   config = function()
  --     require("CopilotChat").setup({
  --       model = "claude-3.5-sonnet",
  --       highlight_headers = false,
  --       separator = "---",
  --       error_header = "> [!ERROR] Error",
  --     })
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   opts = {
  --     suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<C-a>" } },
  --     panel = {
  --       enabled = true,
  --       auto_refresh = false,
  --       keymap = {
  --         jump_prev = "[[",
  --         jump_next = "]]",
  --         accept = "<CR>",
  --         refresh = "gr",
  --         open = "<M-CR>",
  --       },
  --     },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function()
      require("gitsigns").setup({
        current_line_blame = true, -- Enable line blame
      })
    end,
  },
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      -- Document existing key chains
      spec = {
        { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
        { "<leader>d", group = "[D]ebug" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>t", group = "[T]oggles and [T]erminal" },
        { "<leader>g", group = "[G]it" },
        { "<leader>h", group = "[H]arpoon", mode = { "n" } },
        { "<leader>b", group = "[B]uffer" },
        { "<leader>o", group = "[O]bsidian" },
        { "<leader>n", group = "[N]otifications" },
        { "<leader>u", group = "[U]ndo" },
        { "<leader>x", group = "[X]ceptions" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        pickers = {
          find_files = {
            theme = "ivy",
          },
          vimgrep = {
            theme = "ivy",
          },
          live_grep = {
            theme = "ivy",
          },
          buffers = {
            theme = "ivy",
          },
          oldfiles = {
            theme = "ivy",
          },
          help_tags = {
            theme = "ivy",
          },
          keymaps = {
            theme = "ivy",
          },
          lsp_definitions = {
            theme = "ivy",
          },
          lsp_implementations = {
            theme = "ivy",
          },
          lsp_code_actions = {
            theme = "ivy",
          },
          lsp_document_diagnostics = {
            theme = "ivy",
          },
          lsp_workspace_diagnostics = {
            theme = "ivy",
          },
          lsp_workspace_symbols = {
            theme = "ivy",
          },
          lsp_dynamic_workspace_symbols = {
            theme = "ivy",
          },
          lsp_document_formatting = {
            theme = "ivy",
          },
          lsp_range_code_actions = {
            theme = "ivy",
          },
          lsp_workspace_code_actions = {
            theme = "ivy",
          },
          lsp_references = {
            theme = "ivy",
          },
          lsp_type_definitions = {
            theme = "ivy",
          },
          lsp_rename = {
            theme = "ivy",
          },
          lsp_code_lens = {
            theme = "ivy",
          },
          lsp_document_symbols = {
            theme = "ivy",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          fzf = {},
        },
      })

      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local make_entry = require("telescope.make_entry")
      local conf = require("telescope.config").values

      local live_multigrep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()

        local finder = finders.new_async_job({
          command_generator = function(prompt)
            if not prompt or prompt == "" then
              return nil
            end

            local pieces = vim.split(prompt, "  ")
            local args = { "rg" }

            if pieces[1] then
              table.insert(args, "-e")
              table.insert(args, pieces[1])
            end

            if pieces[2] then
              table.insert(args, "-g")
              table.insert(args, pieces[2])
            end

            -- ignore sql files
            table.insert(args, "-g")
            table.insert(args, "!*.sql")

            -- ignore bak files
            table.insert(args, "-g")
            table.insert(args, "!*.bak")

            ---@diagnostic disable-next-line: deprecated
            return vim.tbl_flatten({
              args,
              {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
              },
            })
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cwd = opts.cwd,
        })

        pickers
          .new(opts, {
            theme = "ivy",
            prompt_prefix = "🔍 ",
            selection_strategy = "reset",
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.9,
              height = 0.9,
              prompt_position = "top",
            },
            debounce = 100,
            prompt_title = "Multi Grep",
            finder = finder,
            previewer = conf.grep_previewer(opts),
            sorter = require("telescope.sorters").empty(),
          })
          :find()
      end

      vim.keymap.set("n", "<leader>s/", live_multigrep, { desc = "[S]earch by [/]Grep" })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", function()
        require("telescope.builtin").find_files({ hidden = true })
      end, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>sg", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [G] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- "saghen/blink.cmp",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      -- local capabilities = require("blink.cmp").get_lsp_capabilities()
      local servers = {
        intelephense = {
          capabilities = capabilities,
        },
        gopls = {
          capabilities = capabilities,
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
            },
          },
        },
        omnisharp = {
          cmd = {
            "/home/caiogallo/.cache/omnisharp-vim/omnisharp-roslyn/OmniSharp",
            "--languageserver",
            "--hostPID",
            tostring(vim.fn.getpid()),
          },
          capabilities = capabilities,
        },
        lua_ls = {
          capabilities = capabilities,
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      }

      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true, php = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = "never"
        else
          lsp_format_opt = "fallback"
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        sql = { "sql_formatter" },
      },
    },
  },
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {},
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ["<C-Space>"] = cmp.mapping.complete({}),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        }),
        sources = {
          {
            name = "lazydev",
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme("tokyonight-night")

      -- You can configure highlights by doing something like:
      vim.cmd.hi("Comment gui=none")
    end,
  },
  -- {
  --   "nyoom-engineering/oxocarbon.nvim",
  --   init = function()
  --     vim.opt.background = "dark" -- set this to dark or light
  --     vim.cmd.colorscheme("oxocarbon")
  --   end,
  -- },
  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          s = { "%[%[().-()%]%]" },
          F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        },
      })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require("mini.statusline")
      -- set use_icons to true if you have a Nerd Font
      -- statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return "%2l:%-2v"
      -- end

      require("mini.pairs").setup()

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          -- section_separators = { "", "" },
          -- component_separators = { "", "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",

              -- Table of diagnostic sources, available sources are:
              --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
              -- or a function that returns a table as such:
              --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
              sources = { "nvim_diagnostic", "nvim_lsp" },

              -- Displays diagnostics for the defined severity types
              sections = { "error", "warn", "info", "hint" },

              diagnostics_color = {
                -- Same values as the general color option can be used here.
                error = "DiagnosticError", -- Changes diagnostics' error color.
                warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                info = "DiagnosticInfo", -- Changes diagnostics' info color.
                hint = "DiagnosticHint", -- Changes diagnostics' hint color.
              },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
            {
              "filename",
              path = 1,
            },
          },
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg == "" then
                  return ""
                end
                return "recording @" .. reg
              end,
              cond = function()
                return vim.fn.reg_recording() ~= ""
              end,
              color = { fg = "#ff9e64" },
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress", "location" },
          lualine_z = {
            {
              "datetime",
              style = "%a, %b %d | %H:%M",
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { "nvim-tree" },
      })
    end,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "php",
        "go",
        "javascript",
        "typescript",
        "json",
        "yaml",
        "css",
        "tsx",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = "custom.plugins" },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- [[ Custom Keymaps ]]
-- See `:help vim.keymap.set()`

-- basic telescope configuration
local conf = require("telescope.config").values
function Toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

local neo = require("neogit")
function Open_Neogit()
  neo.open()
end

vim.keymap.set("n", "<leader>gn", "<cmd>lua Open_Neogit()<CR>", { noremap = true, silent = true, desc = "Open NeoGit" })

-- vim.keymap.set("n", "<leader>gC", ':lua require"CopilotChat".open()<CR>', { desc = "CopilotChat" })
vim.keymap.set("n", "<leader>gn", "<cmd>lua Open_Neogit()<CR>", { desc = "Neogit" })

local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon Add" })
vim.keymap.set("n", "<leader>hc", function()
  harpoon:list():clear()
end, { desc = "Harpoon Clear List" })
vim.keymap.set("n", "<leader>hh", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })
vim.keymap.set("n", "<leader>ht", function()
  Toggle_telescope(harpoon:list())
end, { desc = "Telescope" })

vim.keymap.set("n", "<M-u>", function()
  harpoon:list():select(1)
end, { desc = "select 1" })
vim.keymap.set("n", "<M-i>", function()
  harpoon:list():select(2)
end, { desc = "select 2" })
vim.keymap.set("n", "<M-o>", function()
  harpoon:list():select(3)
end, { desc = "select 3" })
vim.keymap.set("n", "<M-p>", function()
  harpoon:list():select(4)
end, { desc = "select 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-M-p>", function()
  harpoon:list():prev()
end, { desc = "Harpoon Prev" })
vim.keymap.set("n", "<C-M-n>", function()
  harpoon:list():next()
end, { desc = "Harpoon Next" })

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, silent = true, desc = "Oil" })

vim.keymap.set("n", "L", ":bn<CR>", { noremap = true, silent = true, desc = "Next Buffer" })
vim.keymap.set("n", "H", ":bp<CR>", { noremap = true, silent = true, desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { noremap = true, silent = true, desc = "New Buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Delete Buffer" })
vim.keymap.set(
  "n",
  "<leader>bo",
  ":%bd|e#|bd#<CR>",
  { noremap = true, silent = true, desc = "Delete All Buffers Except Current" }
)

vim.keymap.set("n", "<leader>ba", ":%bd<CR>", { noremap = true, silent = true, desc = "Delete All Buffers" })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true, desc = "Tab Next" })
vim.keymap.set("n", "<leader>tp", ":tabprev<CR>", { noremap = true, silent = true, desc = "Tab Previous" })

vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>", { noremap = true, silent = true, desc = "Undotree Toggle" })

vim.keymap.set("n", "<leader>qn", ":cnext<CR>", { noremap = true, silent = true, desc = "Next Quickfix Item" })
vim.keymap.set("n", "<leader>qp", ":cprev<CR>", { noremap = true, silent = true, desc = "Previous Quickfix Item" })
vim.keymap.set("n", "<leader>qd", ":cdo ", { noremap = true, silent = true, desc = "Quickfix Do" })

vim.keymap.set("n", "<space>tb", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
  vim.api.nvim_feedkeys("i", "n", true)
end, { noremap = true, silent = true, desc = "Bottom Docked Terminal" })

-- Custom Plugins

-- Floaterminal
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      vim.api.nvim_feedkeys("i", "n", true)
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Example usage:
-- Create a floating window with default dimensions
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set("n", "<leader>tt", toggle_terminal, { noremap = true, silent = true, desc = "Toggle Terminal" })
vim.keymap.set({ "n", "t" }, "<M-t>", toggle_terminal, { noremap = true, silent = true, desc = "Toggle Terminal" })
--Floaterminal

-- Top
local toggle_top = function(opts)
  opts = opts or {}

  -- Create an immutable scratch buffer that is wiped once hidden
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  -- Create a floating window using the scratch buffer positioned in the middle
  local height = math.ceil(vim.o.lines * 0.8) -- 80% of screen height
  local width = math.ceil(vim.o.columns * 0.8) -- 80% of screen width
  local win = vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.ceil((vim.o.lines - height) / 2),
    col = math.ceil((vim.o.columns - width) / 2),
    border = "rounded",
  })

  -- Change to the window that is floating to ensure termopen uses correct size
  vim.api.nvim_set_current_win(win)

  -- Launch top, and configure to close the window when the process exits
  vim.fn.termopen({ "htop" }, {
    on_exit = function(_, _, _)
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  -- Start in terminal mode
  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command("Top", toggle_top, {})
vim.keymap.set("n", "<leader>tr", toggle_top, { noremap = true, silent = true, desc = "Toggle Top" })
-- Top

-- cht.sh
require("custom.plugins.chtsh").setup()
-- cht.sh

---------------------
--- Custom Macros ---
---------------------

--- OBS: ^[ = Esc

vim.fn.setreg("l", "yovar_dump(^[pA;^[")
vim.fn.setreg("d", "yovar_dump(^[A;^[hi^[pAexit;^[")
vim.fn.setreg("j", "yoconsole.log(^[pA;^[bbba'^[pli:^[la, ^[")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
