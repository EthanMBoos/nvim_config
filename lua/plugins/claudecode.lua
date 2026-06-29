-- Auth: run `claude` once from a terminal after installing the CLI. It opens a
-- browser to log in; this plugin then connects automatically to that session.
return {
  {
    'coder/claudecode.nvim',
    opts = {},
    keys = {
      { '<leader>ac', '<cmd>ClaudeCode<CR>',          desc = '[A]I [C]laude toggle' },
      { '<leader>as', '<cmd>ClaudeCodeSend<CR>',      mode = 'v', desc = '[A]I [S]end selection' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<CR>', desc = '[A]I [R]esume session' },
    },
  },
}
