-- Snippet engine + autocomplete
-- kickstart switched to blink.cmp; keeping that choice (it's faster than nvim-cmp)

return {
  {
    'L3MON4D3/LuaSnip',
    version = '2.*',
    build = (vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1) and 'make install_jsregexp' or nil,
    opts = {},
  },

  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      keymap = {
        preset = 'default',
        ['<C-k>'] = { 'show_documentation', 'fallback' },
      },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
    },
  },
}
