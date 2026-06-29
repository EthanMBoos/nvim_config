vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Buffer cycling
vim.keymap.set('n', '<Tab>',     '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>',   '<cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<CR>',             { desc = 'Close buffer' })

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit builtin terminal mode more intuitively
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window splits — matches Ghostty pane keys (alt+\ and alt+-)
vim.keymap.set('n', '<leader>\\', '<cmd>vsp<CR>',   { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>-',  '<cmd>sp<CR>',    { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>w',  '<cmd>close<CR>', { desc = 'Close current [W]indow' })

-- Window resize — alt+hjkl (shared with Ghostty pane resize via performable:)
vim.keymap.set('n', '<M-h>', '<cmd>vertical resize +5<CR>', { desc = 'Grow window width' })
vim.keymap.set('n', '<M-l>', '<cmd>vertical resize -5<CR>', { desc = 'Shrink window width' })
vim.keymap.set('n', '<M-k>', '<cmd>resize +3<CR>',          { desc = 'Grow window height' })
vim.keymap.set('n', '<M-j>', '<cmd>resize -3<CR>',          { desc = 'Shrink window height' })
