# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Tool | Config Path | Description |
| --- | --- | --- |
| Zsh | `.zshrc` | Shell configuration with Oh My Zsh, plugins, and aliases |
| Starship | `.config/starship.toml` | Cross-shell prompt |
| Alacritty | `.config/alacritty/` | Terminal emulator |
| Kitty | `.config/kitty/` | Terminal emulator |
| WezTerm | `.config/wezterm/` | Terminal emulator |
| tmux | `.config/tmux/` | Terminal multiplexer |
| Neovim | `.config/nvim/` | Text editor (Kickstart.nvim-based) |
| opencode | `.config/opencode/` | AI coding assistant |

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) (used across all terminal configs)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/oscarli916/dotfiles.git ~/personal/dotfiles
   ```

2. Navigate to the dotfiles directory:

   ```bash
   cd ~/personal/dotfiles
   ```

3. Run the automated install script to install all tools and symlink configs:

   ```bash
   bash install/install.sh
   ```

   This will install all dependencies, set up tools, and run `stow -t ~ .` to symlink everything into your home directory.

   Alternatively, you can run individual install scripts from `install/` if you only need specific tools.

### What the Install Scripts Set Up

| Script | Tool | Method |
| --- | --- | --- |
| `install-stow.sh` | GNU Stow + symlinks configs | Package manager |
| `install-zsh.sh` | Zsh (set as default shell) | Package manager |
| `install-oh-my-zsh.sh` | Oh My Zsh + zsh-autosuggestions + zsh-syntax-highlighting | curl + git clone |
| `install-starship.sh` | Starship prompt | Official install script (`~/.local/bin`) |
| `install-fzf.sh` | fzf fuzzy finder | git clone (`~/.fzf`) |
| `install-lsd.sh` | LSD (modern `ls` replacement) | Package manager |
| `install-tmux.sh` | tmux 3.5a + TPM | Source build (`~/.local`) |
| `install-nvim.sh` | Neovim v0.11.4 | Source build (`~/.local`) |
| `install-ripgrep.sh` | ripgrep 15.1.0 | Binary download (`~/.local/bin`) |
| `install-opencode.sh` | opencode | Official install script (`~/.opencode/bin`) |

All scripts are idempotent and support Debian/Ubuntu (apt), Fedora (dnf), and Arch (pacman).

### Post-Install Steps

1. Press `Ctrl+R` to verify fzf is working
2. Run `ls` to verify lsd is active
3. In tmux, press `Ctrl+A` then `I` to install tmux plugins via TPM
4. Open Neovim to let lazy.nvim auto-install plugins

## Configuration Details

### Shell (Zsh)

**Framework:** Oh My Zsh

**Plugins:**

- `git` -- git aliases and functions
- `zsh-autosuggestions` -- fish-like autosuggestions (strategy: completion, then history)
- `zsh-syntax-highlighting` -- real-time command syntax highlighting

**Prompt:** Starship (overrides the Oh My Zsh theme)

- Full directory path displayed (no truncation)
- Git branch shown with truncation length of 40
- Docker context, language/tool modules included

**fzf Integration:** Sourced from `~/.fzf.zsh`, providing `Ctrl+T`, `Ctrl+R`, and `Alt+C` bindings.

### Aliases

| Alias | Command | Description |
| --- | --- | --- |
| `ls` | `lsd` | Modern ls with icons |
| `l` | `ls -l` | Long listing |
| `la` | `ls -a` | Show all files |
| `lla` | `ls -la` | Long listing, all files |
| `lt` | `ls --tree` | Tree view |
| `c` | `clear` | Clear terminal |
| `v` / `nv` / `n` | `nvim` | Open Neovim |
| `docker` | `podman` | Use podman as docker |

### Terminal Emulators

| Terminal | Color Scheme | Font | Size |
| --- | --- | --- | --- |
| Alacritty | Catppuccin Mocha | JetBrainsMono Nerd Font Mono | 12pt |
| Kitty | Tokyo Night | JetBrainsMono Nerd Font | 10pt |
| WezTerm | Catppuccin Mocha | JetBrainsMono Nerd Font Mono | 12pt |

### tmux

**Prefix key:** `Ctrl+A`

**Theme:** Catppuccin Mocha (v2.1.3)

**Plugins (via TPM):**

- `tmux-plugins/tpm` -- plugin manager
- `catppuccin/tmux` -- theme

**Key bindings:**

| Binding | Action |
| --- | --- |
| `prefix + r` | Reload tmux config |
| `prefix + h/j/k/l` | Vim-style pane navigation |
| `prefix + \|` | Horizontal split |
| `prefix + _` | Vertical split |

**Other settings:** Mouse enabled, windows/panes numbered from 1, status bar at top.

### Neovim

Based on [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) -- single-file configuration in `init.lua`.

**Colorscheme:** tokyonight-night

**Plugin manager:** lazy.nvim (auto-bootstrapped)

**Plugins:**

| Plugin | Purpose |
| --- | --- |
| `folke/tokyonight.nvim` | Colorscheme |
| `folke/which-key.nvim` | Keybinding hints |
| `folke/todo-comments.nvim` | Highlight TODO/NOTE comments |
| `folke/lazydev.nvim` | Lua LSP for Neovim config |
| `nvim-telescope/telescope.nvim` | Fuzzy finder |
| `nvim-telescope/telescope-fzf-native.nvim` | FZF algorithm for Telescope |
| `nvim-telescope/telescope-ui-select.nvim` | UI select via Telescope |
| `lewis6991/gitsigns.nvim` | Git signs in gutter |
| `neovim/nvim-lspconfig` | LSP client configuration |
| `mason-org/mason.nvim` | LSP/tool installer |
| `mason-org/mason-lspconfig.nvim` | Mason + lspconfig bridge |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | Auto-install Mason tools |
| `j-hui/fidget.nvim` | LSP progress indicator |
| `stevearc/conform.nvim` | Autoformatting on save |
| `saghen/blink.cmp` | Autocompletion engine |
| `L3MON4D3/LuaSnip` | Snippet engine |
| `NMAC427/guess-indent.nvim` | Auto-detect indentation |
| `echasnovski/mini.nvim` | Textobjects, surround, statusline |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting/parsing |
| `NeogitOrg/neogit` | Git UI (Magit-like) |
| `sindrets/diffview.nvim` | Diff viewer |

**LSP servers:** `lua_ls` (configured via Mason)

**Formatters (conform.nvim):**

| Language | Formatter |
| --- | --- |
| Lua | stylua |
| JavaScript / TypeScript / JSX / TSX | prettier |

**Key keymaps:**

| Keymap | Action |
| --- | --- |
| `<leader>sf` | Search files |
| `<leader>sg` | Search by grep |
| `<leader>sh` | Search help |
| `<leader>sk` | Search keymaps |
| `<leader>sd` | Search diagnostics |
| `<leader>sw` | Search current word |
| `<leader>sr` | Resume last search |
| `<leader>s.` | Search recent files |
| `<leader><leader>` | Find buffers |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader>sn` | Search Neovim config files |
| `<leader>f` | Format buffer |
| `<leader>q` | Open diagnostic quickfix list |
| `<leader>th` | Toggle inlay hints |
| `<leader>gg` | Open Neogit |
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gD` | Go to declaration |
| `grn` | Rename symbol |
| `gra` | Code action |
| `<C-d>` / `<C-u>` | Half-page down/up + center |
| `<C-h/j/k/l>` | Window navigation |

Leader key is `Space`.

### opencode

[opencode](https://opencode.ai/) is an AI-powered coding assistant (TUI). Configured with the "github" theme.

## tmux-sessionizer

A custom project session launcher script (inspired by ThePrimeagen's workflow), bound to `Ctrl+F` in Zsh.

Uses `fzf` to fuzzy-select a project directory from `~/personal/` and creates a tmux session with 3 windows:

1. **Neovim** (`nvim .`) -- focused by default
2. **Shell** -- for running commands
3. **opencode** -- AI coding assistant

If a session for the selected project already exists, it switches to it instead of creating a new one.

## Uninstallation

To remove the symlinks:

```bash
cd ~/personal/dotfiles
stow -t ~ -D .
```
