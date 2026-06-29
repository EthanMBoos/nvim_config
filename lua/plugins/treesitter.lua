-- nvim-treesitter (master branch)
-- Uses the system C compiler to compile parsers — no tree-sitter CLI required.
-- If highlighting breaks after a Neovim upgrade, wipe the parser cache and re-run
-- :TSUpdate to get fresh binaries compiled against the new Neovim ABI:
--   rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser/
--
-- Neovim 0.12 ships bundled parsers and queries for markdown/markdown_inline.
-- nvim-treesitter's markdown injection queries use a custom set-lang-from-info-string!
-- directive that, when merged with Neovim's own queries on the runtimepath, produces
-- nil nodes during injection processing and crashes the treesitter highlighter.
-- We override the compiled injection query after setup to use only Neovim's clean version.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
          'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- Replace the merged (broken) markdown injection query with Neovim's bundled
      -- version. nvim-treesitter's injections.scm uses set-lang-from-info-string!
      -- which conflicts with Neovim 0.12's injection processing when both are merged.
      vim.treesitter.query.set('markdown', 'injections', [[
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
      ]])
    end,
  },
}
