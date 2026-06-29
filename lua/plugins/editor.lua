-- Editing utilities: indent detection, git signs, which-key, mini, telescope, formatter

return {
  -- Jump anywhere on screen with labeled targets; also overlays labels on / search matches
  {
    'folke/flash.nvim',
    keys = {
      { 's',     function() require('flash').jump() end,              mode = { 'n', 'x', 'o' }, desc = 'Flash jump' },
      { 'S',     function() require('flash').treesitter() end,        mode = { 'n', 'x', 'o' }, desc = 'Flash treesitter select' },
      { 'r',     function() require('flash').remote() end,            mode = 'o',               desc = 'Flash remote' },
      { '<C-s>', function() require('flash').toggle() end,            mode = 'c',               desc = 'Flash toggle in search' },
    },
  },

  -- Log file highlighting — covers ROS log format ([INFO]/[WARN]/[ERROR] + timestamps)
  { 'fei6409/log-highlight.nvim', opts = {} },

  -- Find and replace across codebase
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      { '<leader>fr', '<cmd>GrugFar<CR>', desc = '[F]ind and [R]eplace (grug-far)' },
    },
    opts = {},
  },

  -- File explorer tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file [E]xplorer' },
    },
    opts = {
      filters = { dotfiles = false },
      renderer = { group_empty = true },
    },
  },

  -- Auto-detect tabstop / shiftwidth per file
  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Git diff viewer and file history
  {
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>',            desc = '[G]it [D]iff against HEAD' },
      { '<leader>gc', '<cmd>DiffviewClose<CR>',           desc = '[G]it diff [C]lose' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>',   desc = '[G]it [H]istory (current file)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<CR>',     desc = '[G]it [H]istory (repo)' },
      { '<leader>gL', ':<C-u>DiffviewFileHistory --follow -L<C-r>=line("\'<")<CR>,<C-r>=line("\'>")<CR>:%<CR>', mode = 'v', desc = '[G]it [L]ine history (selection)' },
    },
  },

  -- Git diff signs in the gutter + hunk-level ops (navigate, stage, reset, preview)
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '' },
        topdelete    = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end
        map(']c', gs.next_hunk,     'Next git hunk')
        map('[c', gs.prev_hunk,     'Prev git hunk')
        map('<leader>gp', gs.preview_hunk, '[G]it [P]review hunk')
        map('<leader>gS', gs.stage_hunk,   '[G]it [S]tage hunk')
        map('<leader>gR', gs.reset_hunk,   '[G]it [R]eset hunk')
      end,
    },
  },

  -- Pending keymap hint popup
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>a', group = '[A]I' },
        { '<leader>f', group = '[F]ind/[F]iles' },
        { '<leader>s', group = '[S]earch',    mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>g', group = '[G]it' },
        { 'gr',        group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  -- Highlight TODO / FIXME / HACK etc in comments
  { 'folke/todo-comments.nvim', opts = { signs = false } },

  -- mini.ai (extended text objects) + mini.surround
  -- NOTE: mini.statusline intentionally omitted — NvChad ui owns the statusline
  -- NOTE: mini.icons intentionally omitted — using nvim-web-devicons (NvChad dep)
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.pairs').setup()
      require('mini.ai').setup {
        -- Avoid conflicts with Neovim 0.12+ built-in incremental selection
        mappings = { around_next = 'aa', inside_next = 'ii' },
        n_lines = 500,
      }
      require('mini.surround').setup()
    end,
  },

  -- Fuzzy finder: files, LSP, help, buffers, grep
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              width = 0.87,
              height = 0.80,
            },
          },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local b = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', b.help_tags,    { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', b.keymaps,      { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>ff', b.find_files,   { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fw', b.live_grep,    { desc = '[F]ind by [W]ord (grep)' })
      vim.keymap.set('n', '<leader>ss', b.builtin,      { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', b.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sd', b.diagnostics,  { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', b.resume,       { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', b.oldfiles,     { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sc', b.commands,     { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader><leader>', b.buffers, { desc = '[ ] Find existing buffers' })

      -- Telescope-based LSP pickers wired up when a server attaches
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          vim.keymap.set('n', 'grr', b.lsp_references,                { buffer = buf, desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', 'gri', b.lsp_implementations,           { buffer = buf, desc = '[G]oto [I]mplementation' })
          vim.keymap.set('n', 'grd', b.lsp_definitions,               { buffer = buf, desc = '[G]oto [D]efinition' })
          vim.keymap.set('n', 'gO',  b.lsp_document_symbols,          { buffer = buf, desc = 'Open Document Symbols' })
          vim.keymap.set('n', 'gW',  b.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
          vim.keymap.set('n', 'grt', b.lsp_type_definitions,          { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })

      vim.keymap.set('n', '<leader>/', function()
        b.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        b.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        b.find_files { cwd = vim.fn.stdpath 'config', follow = true }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- Code formatter (format-on-save disabled by default; enable per filetype as needed)
  {
    'stevearc/conform.nvim',
    keys = {
      {
        '<leader>F',
        function() require('conform').format { async = true } end,
        mode = { 'n', 'v' },
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local enabled = {}
        if enabled[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
      end,
      default_format_opts = { lsp_format = 'fallback' },
      formatters_by_ft = {
        -- lua = { 'stylua' },
      },
    },
  },
}
