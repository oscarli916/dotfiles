# Dotfiles

Personal dotfiles managed with GNU Stow.

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) must be installed

  ```bash
  # Debian/Ubuntu
  sudo apt install stow

  # macOS
  brew install stow

  # Arch Linux
  sudo pacman -S stow
  ```

## Installation

1. Clone the repository:

   ```bash
   git clone <repo-url> ~/personal/dotfiles
   ```

2. Navigate to the dotfiles directory:

   ```bash
   cd ~/personal/dotfiles
   ```

3. Symlink the dotfiles to your home directory:

   ```bash
   stow -t ~ .
   ```

   This creates symlinks in your home directory (`~`) pointing to the files in this repository.

## Uninstallation

To remove the symlinks:

```bash
cd ~/personal/dotfiles
stow -t ~ -D .
```
