# RoamNvim

Ghostty handles terminal splits and pane navigation. `Ctrl+H/J/K/L` moves between Neovim windows and Ghostty panes with the same keys on both platforms, replacing what tmux used to do. Shell config is included. Complex LSP scenarios like ROS C++ inside Docker are documented with working configs, not stubs. Only what gets used is here.

kickstart.nvim base · catppuccin · heirline · bufferline · claudecode.nvim

## macOS setup

```bash
# 1. Dependencies
brew install neovim git ripgrep fd make go node fzf lazygit
brew install --cask font-jetbrains-mono-nerd-font ghostty
npm install -g @anthropic-ai/claude-code

# 2. Clone this repo, then run the rest from inside it
git clone <this-repo-url> RoamNvim && cd RoamNvim

# 3. Ghostty config
mkdir -p ~/.config/ghostty
cp ./ghostty/config ~/.config/ghostty/config

# 4. Shell config (appends vi mode + fzf to existing zshrc)
cat ./shell/zshrc >> ~/.zshrc && source ~/.zshrc

# 5. Neovim config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
ln -s "$(pwd)" ~/.config/nvim

# 6. First launch. Plugins install automatically; quit and reopen for the theme cache.
nvim

# 7. LSP servers are auto-installed by mason on first file open (no action needed)
#    clangd / ts_ls / gopls / jsonls / yamlls / marksman / lua_ls
#    Exception: ROS C++ needs clangd installed inside the Docker container.
#    See docs/ros1-docker-clangd.md for that setup.
```

## Linux setup

```bash
# 1. Dependencies (apt; adjust for your distro)
sudo apt install neovim git ripgrep fd-find make golang-go nodejs npm fzf
npm install -g @anthropic-ai/claude-code
# Install JetBrainsMono Nerd Font manually: https://www.nerdfonts.com/font-downloads
# Install Ghostty: https://ghostty.org

# 2. Clone this repo, then run the rest from inside it
git clone <this-repo-url> RoamNvim && cd RoamNvim

# 3. Ghostty config
mkdir -p ~/.config/ghostty
cp ./ghostty/config ~/.config/ghostty/config

# 4. Shell config (appends vi mode + fzf to existing bashrc)
cat ./shell/bashrc >> ~/.bashrc && source ~/.bashrc

# 5. Neovim config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
ln -s "$(pwd)" ~/.config/nvim

# 6. First launch. Plugins install automatically; quit and reopen for the theme cache.
nvim

# 7. LSP servers are auto-installed by mason on first file open (no action needed)
#    clangd / ts_ls / gopls / jsonls / yamlls / marksman / lua_ls
#    Exception: ROS C++ needs clangd installed inside the Docker container.
#    See docs/ros1-docker-clangd.md for that setup.
```

## Navigation

Unified across Ghostty panes and Neovim windows. Typical layout: Ghostty horizontal split (Neovim top, terminal bottom) with Neovim vertical splits inside.

| Key | Action |
|---|---|
| `<Space>\` / `<Space>-` | New Neovim split vertical / horizontal |
| `Alt+\` / `Alt+-` | New Ghostty pane vertical / horizontal |
| `Ctrl+Shift+T` | New Ghostty tab (independent pane layout per tab) |
| `<Space>w` / `Ctrl+Shift+W` | Close Neovim window / Ghostty pane |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous Ghostty tab |
| `Ctrl+H/J/K/L` | Navigate between Neovim windows and Ghostty panes |
| `Alt+Shift+H/J/K/L` | Resize Ghostty pane |
| `Alt+H/J/K/L` | Resize Neovim window |

## Neovim

Leader is `<Space>`. Press `<Space>` to see everything via which-key.

| Key | Action |
|---|---|
| `<Space>e` | Toggle file explorer |
| `<Space>ff` / `<Space>fw` | Find files / live grep |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<Space>x` | Close buffer |
| `<Space><Space>` | Find open buffers |
| `<Space>F` | Format buffer |
| `gra` / `grn` / `grr` | LSP action / rename / references |
| `grd` / `gri` / `grt` | LSP definition / implementation / type |
| `]c` / `[c` | Next / previous git hunk |
| `<Space>gp/gS/gR` | Hunk: preview / stage / reset (gitsigns) |
| `<Space>gd/gc/gh/gH` | Diffview: open / close / file history / repo history |
| `<Space>gL` (visual) | Diffview: history for selected lines |
| `<Space>fr` | Find and replace across codebase (grug-far) |
| `<Space>ac` / `<Space>as` / `<Space>ar` | Claude: toggle / send selection / resume session |
| `<Space>q` | Open diagnostic quickfix list |

## Git workflow

**gitsigns: in-buffer hunk navigation and staging.**

| Key | Action |
|---|---|
| `]c` / `[c` | Jump to next / previous hunk |
| `<Space>gp` | Preview hunk diff inline |
| `<Space>gS` | Stage this hunk only |
| `<Space>gR` | Reset (discard) this hunk |

**diffview: review changes and history before committing.**

| Key | Action |
|---|---|
| `<Space>gd` | Diff all changes against HEAD |
| `<Space>gh` | File history (current file) |
| `<Space>gH` | File history (whole repo) |
| `<Space>gL` (visual) | History for selected lines |
| `<Space>gc` | Close diffview |

**lazygit: everything else** (commit, push/pull, branch management, rebase, blame). Run `lazygit` from your Ghostty terminal.

## Ghostty

| Key | Action |
|---|---|
| `Ctrl+Shift+C/V` | Copy / paste |
| `Ctrl+Shift+T/N/W` | New tab / window / close |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tab |
| `Alt+\` / `Alt+-` | New pane vertical / horizontal |

## Shell (vi mode)

Press `Esc` at the prompt to enter normal mode.

| Key | Action |
|---|---|
| `k` / `j` | History up / down |
| `h` / `l` | Move cursor left / right |
| `w` / `b` | Jump forward / back by word |
| `0` / `$` | Start / end of line |
| `x` | Delete character |
| `v` | Edit command in Neovim, `:wq` to run |
| `i` / `a` | Back to insert mode |
| `Ctrl+R` | Fuzzy search history (fzf) |
| `Ctrl+T` | Fuzzy file picker, inserts path at cursor |
| `history \| fzf` | Search history and pipe result anywhere |

Pipe output to `less` to search through it (replaces Ctrl+U/D scrollback):

```bash
command | less
```

| Key | Action |
|---|---|
| `j` / `k` | Scroll line by line |
| `Ctrl+D` / `Ctrl+U` | Half page down / up |
| `/pattern` | Search forward |
| `n` / `N` | Next / previous match |
| `g` / `G` | Top / bottom |
| `v` | Open in Neovim |
| `q` | Quit back to shell |

## Troubleshooting

**Markdown has no highlighting**: wipe the treesitter cache and reinstall:
```bash
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser/
```
Then `:TSUpdate` inside Neovim.

**Theme not applied**: run `:Lazy reload catppuccin` or restart Neovim.
