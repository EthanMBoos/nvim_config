-- UI stack: catppuccin colorscheme + heirline statusline + bufferline tabs

return {
  -- Colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      integrations = {
        blink_cmp    = true,
        gitsigns     = true,
        nvimtree     = true,
        telescope    = { enabled = true },
        which_key    = true,
        mini         = { enabled = true },
        treesitter   = true,
        bufferline   = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- Statusline
  {
    'rebelot/heirline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'catppuccin/nvim',
    },
    config = function()
      local conditions = require 'heirline.conditions'
      local utils      = require 'heirline.utils'
      local palette    = require('catppuccin.palettes').get_palette 'mocha'

      require('heirline').load_colors {
        bg      = palette.mantle,
        fg      = palette.text,
        blue    = palette.blue,
        green   = palette.green,
        red     = palette.red,
        yellow  = palette.yellow,
        mauve   = palette.mauve,
        peach   = palette.peach,
        overlay = palette.overlay0,
        surface = palette.surface0,
      }

      local Align = { provider = '%=' }
      local Space = { provider = ' ' }

      -- Mode
      local mode_names = {
        n  = 'NOR', i  = 'INS', v  = 'VIS', V  = 'V-L', ['\22'] = 'V-B',
        c  = 'CMD', R  = 'REP', t  = 'TRM', s  = 'SEL', S  = 'S-L',
      }
      local mode_colors = {
        n  = 'blue',  i  = 'green', v  = 'mauve', V  = 'mauve', ['\22'] = 'mauve',
        c  = 'peach', R  = 'red',   t  = 'green', s  = 'mauve', S  = 'mauve',
      }
      local Mode = {
        init   = function(self) self.mode = vim.fn.mode(1) end,
        update = {
          'ModeChanged',
          pattern  = '*:*',
          callback = vim.schedule_wrap(function() vim.cmd 'redrawstatus' end),
        },
        provider = function(self)
          local m = self.mode:sub(1, 1)
          return ' ' .. (mode_names[m] or m) .. ' '
        end,
        hl = function(self)
          local color = mode_colors[self.mode:sub(1, 1)] or 'blue'
          return { bg = color, fg = 'bg', bold = true }
        end,
      }

      -- Git (gitsigns populates vim.b.gitsigns_status_dict)
      local Git = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status = vim.b.gitsigns_status_dict or {}
        end,
        update = { 'User', pattern = 'GitSignsUpdate' },
        {
          provider = function(self)
            local head = self.status.head or ''
            return head ~= '' and ('  ' .. head .. ' ') or ''
          end,
          hl = { fg = 'mauve', bold = true },
        },
        {
          provider = function(self)
            local s = ''
            if (self.status.added   or 0) > 0 then s = s .. '+' .. self.status.added   end
            if (self.status.changed or 0) > 0 then s = s .. '~' .. self.status.changed end
            if (self.status.removed or 0) > 0 then s = s .. '-' .. self.status.removed end
            return s ~= '' and (s .. ' ') or ''
          end,
          hl = { fg = 'overlay' },
        },
      }

      -- File name
      local FileName = {
        init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
        {
          provider = function(self)
            local name = vim.fn.fnamemodify(self.filename, ':.')
            if name == '' then return '[No Name]' end
            if #name > 40 then name = vim.fn.pathshorten(name) end
            return name
          end,
          hl = { fg = 'fg' },
        },
        {
          provider = function() return vim.bo.modified and ' [+]' or '' end,
          hl = { fg = 'yellow' },
        },
        {
          provider = function()
            return (not vim.bo.modifiable or vim.bo.readonly) and ' [-]' or ''
          end,
          hl = { fg = 'red' },
        },
      }

      -- LSP diagnostics
      local Diagnostics = {
        condition = conditions.has_diagnostics,
        update    = { 'DiagnosticChanged', 'BufEnter' },
        init = function(self)
          self.errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        end,
        {
          provider = function(self) return self.errors   > 0 and (' E:' .. self.errors)   or '' end,
          hl = { fg = 'red' },
        },
        {
          provider = function(self) return self.warnings > 0 and (' W:' .. self.warnings) or '' end,
          hl = { fg = 'yellow' },
        },
        Space,
      }

      -- File type
      local FileType = {
        provider = function() return vim.bo.filetype ~= '' and vim.bo.filetype or '' end,
        hl = { fg = 'overlay' },
      }

      -- Ruler
      local Ruler = {
        provider = ' %3l:%-2c %P ',
        hl = { fg = 'overlay' },
      }

      require('heirline').setup {
        statusline = {
          hl = { bg = 'bg' },
          Mode, Space, Git, FileName, Space,
          Align,
          Diagnostics, FileType, Space, Ruler,
        },
      }
    end,
  },

  -- Buffer tabs
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode                  = 'buffers',
        separator_style       = 'slant',
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon       = false,
        offsets = {
          { filetype = 'NvimTree', text = 'Files', highlight = 'Directory', text_align = 'left' },
        },
      },
    },
  },

  -- Shared deps (lazy dedupes if other plugins also declare these)
  { 'nvim-lua/plenary.nvim',       lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
