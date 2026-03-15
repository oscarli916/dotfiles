# AGENTS.md - Dotfiles Repository

## Global Rules

- Ask questions if you need any clarification before proceeding with a task.
- Do not make assumptions about intent when instructions are ambiguous.
- This is a personal dotfiles repo managed with GNU Stow, not a software project with builds/tests.

## Repository Overview

Personal dotfiles for a WSL-based Linux development environment. Configs are symlinked
into `$HOME` via `stow -t ~ .`. The repo contains configuration for: Zsh, Starship,
Alacritty, Kitty, WezTerm, tmux, Neovim, and opencode.

### Directory Layout

```
.zshrc                          # Zsh shell config (Oh My Zsh, aliases, keybindings)
.stow-local-ignore              # Files/dirs excluded from Stow symlinking
tmux-sessionizer                # Custom tmux session launcher (Zsh script)
install/                        # Idempotent install scripts (not symlinked)
  install.sh                    # Master orchestration script
  install-*.sh                  # Individual tool installers
.config/
  nvim/init.lua                 # Neovim config (single-file, Kickstart.nvim-based)
  nvim/lazy-lock.json           # Neovim plugin lockfile (lazy.nvim)
  tmux/tmux.conf                # tmux config
  alacritty/alacritty.toml      # Alacritty terminal config
  kitty/kitty.conf              # Kitty terminal config
  wezterm/.wezterm.lua          # WezTerm terminal config
  starship.toml                 # Starship prompt config
  opencode/                     # opencode AI assistant config
```

## Build / Install / Deploy Commands

There is no build system, test suite, or CI/CD. The repo is deployed via GNU Stow.

```bash
# Full install (all tools + symlinks) -- requires sudo
bash install/install.sh

# Symlink dotfiles only (Stow must already be installed)
stow -v -t "$HOME" -d ~/personal/dotfiles .

# Remove all symlinks
stow -t ~ -D .

# Run a single install script
bash install/install-<tool>.sh
# Available: stow, zsh, oh-my-zsh, starship, fzf, lsd, tmux, nvim, mise, ripgrep, opencode

# After tmux install, install tmux plugins
# Inside tmux: prefix (Ctrl+A) then I

# After Neovim install, plugins auto-install on first launch
# Check health: :checkhealth
# Update plugins: :Lazy update
# Manage LSP tools: :Mason
```

## Code Style Guidelines

### Shell Scripts (Bash -- install scripts)

- Shebang: `#!/usr/bin/env bash`
- Always set `set -euo pipefail` at the top
- Use a section comment header: `# --- Description ---`
- Detect package manager with `command -v apt/dnf/pacman` pattern
- Make scripts idempotent: check if tool exists before installing
- Use `echo "==> ..."` for progress messages
- Use `echo "Error: ..."` with `exit 1` for failures
- Clean up temp files with `trap "rm -rf $TEMP_DIR" EXIT`
- Quote all variable expansions: `"$VAR"`, `"$HOME/.local/bin"`
- Redirect stderr with `&>/dev/null` or `2>/dev/null`
- Install binaries to `~/.local/bin`; source-built tools to `~/.local`
- Support three package managers: apt (Debian/Ubuntu), dnf (Fedora), pacman (Arch)
- Indentation: tabs (per the Stow/install scripts)

### Shell Config (Zsh -- .zshrc)

- Keep PATH exports at the top
- Group settings by section: exports, plugins, sources, keybindings, aliases
- Aliases are lowercase, short (single letter when possible): `c`, `v`, `n`, `k`
- Use conditional aliases for cross-platform compatibility: `if ! command -v ... >/dev/null 2>&1; then`

### Zsh Scripts (tmux-sessionizer)

- Shebang: `#!/usr/bin/env zsh`
- Use `[[ ... ]]` for conditionals
- Handle "no selection" case: `if [[ -z $selected ]]; then exit 0; fi`

### Lua (Neovim -- init.lua)

- Single-file configuration based on Kickstart.nvim
- Indentation: tabs (not spaces) -- Neovim modeline at EOF: `-- vim: ts=2 sts=2 sw=2 et`
  Note: the modeline says spaces but the actual file uses tabs; follow the existing code (tabs)
- Use `vim.o` for simple options, `vim.opt` for table-like options (e.g., `listchars`)
- Keymap format: `vim.keymap.set(mode, key, action, { desc = "Description" })`
- Keymap descriptions use `[B]racket` notation for which-key: `"[S]earch [F]iles"`
- Plugin specs use lazy.nvim format: `{ "author/plugin", opts = {}, ... }`
- Use `---@diagnostic disable-next-line:` for suppressing specific Lua LS warnings
- Use `---@type`, `---@param`, `---@return` annotations for type hints
- String quoting: double quotes for Lua strings
- Autocommands use `vim.api.nvim_create_autocmd` with a named `group`
- Autocommand groups: `vim.api.nvim_create_augroup("name", { clear = true })`

### Lua (WezTerm -- .wezterm.lua)

- Uses `local wezterm = require("wezterm")` and `local config = wezterm.config_builder()`
- Returns `config` at end of file

### TOML (Alacritty, Starship)

- Standard TOML formatting
- Alacritty uses `import` for external color scheme files
- Starship uses `[section]` blocks with brief inline comments

### tmux Config

- Comments with `#` at start of line, grouped by purpose
- Plugin declarations: `set -g @plugin 'author/plugin'`
- Theme config grouped together after plugin declarations
- TPM initialization must remain at the very bottom of the file

## Formatting Tools (Neovim-managed)

- **Lua**: `stylua` (auto-installed by Mason, runs on save via conform.nvim)
- **JavaScript/TypeScript/JSX/TSX**: `prettier` (runs on save via conform.nvim)
- **C/C++**: format-on-save intentionally disabled

If editing `.config/nvim/init.lua`, ensure `stylua` formatting is respected.

## Error Handling Patterns

### Shell Scripts

```bash
# Check prerequisites
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed."
    exit 1
fi

# Idempotency guard
if command -v rg &>/dev/null; then
    echo "==> ripgrep already installed, skipping"
    exit 0
fi

# Unsupported platform
echo "Error: No supported package manager found (apt, dnf, pacman)."
exit 1
```

### Neovim Lua

- Use `pcall` for optional operations: `pcall(require("telescope").load_extension, "fzf")`
- Use `vim.fn.has("nvim-0.11")` for version-conditional behavior
- Check `vim.fn.executable("make") == 1` before build steps

## Key Conventions

- **Theme**: Catppuccin Mocha for terminals/tmux; Tokyo Night for Neovim
- **Font**: JetBrainsMono Nerd Font (Mono variant) across all terminals
- **Leader key**: Space (Neovim)
- **tmux prefix**: Ctrl+A
- **Stow exclusions** (`.stow-local-ignore`): `.git`, `README`, `install/`, `tmux-sessionizer`
- **Install target**: `~/.local/bin` for user binaries, `~/.local` for source builds
- **Neovim plugin lockfile**: `.config/nvim/lazy-lock.json` -- commit changes to this file
  when plugins are updated via `:Lazy update`

## Important Warnings

- Do not add files to the repo root carelessly -- Stow will symlink them into `$HOME`
- Check `.stow-local-ignore` when adding new top-level files that should NOT be symlinked
- The `install/` directory and `tmux-sessionizer` are excluded from Stow via `.stow-local-ignore`
- Neovim config is a single file (`init.lua`); do not split into modules without explicit request
- No CI/CD or automated tests exist; manually verify changes work after editing
