# dotfiles

Personal macOS development environment managed by [Dotbot](https://github.com/anishathalye/dotbot).

This setup is optimized for Apple Silicon Macs and uses a modernized tool stack for performance and developer experience.

## Modernized Tool Stack

| Category | Tool | Description |
| :--- | :--- | :--- |
| **Terminal** | [Ghostty](https://ghostty.org/) | Fast, native, GPU-accelerated terminal |
| **Shell** | [Fish](https://fishshell.com/) | User-friendly interactive shell |
| **Prompt** | [Starship](https://starship.rs/) | Minimal, blazing-fast, and infinitely customizable prompt |
| **Editor** | [LazyVim](https://www.lazyvim.org/) | Neovim setup powered by lazy.nvim |
| **Runtimes** | [mise](https://mise.jdx.dev/) | Polyglot runtime manager (ASDF replacement) |
| **Package Manager** | [Homebrew](https://brew.sh/) | Declarative setup via `Brewfile` |

## Fresh Install

Follow these steps in order to set up a new machine from scratch.

### 1. Xcode Command Line Tools
Install the baseline developer tools:
```bash
xcode-select --install
```

### 2. Clone the Repository
Clone with submodules to get Dotbot and other dependencies:
```bash
git clone --recursive https://github.com/zentetsukenz/dotfiles ~/workspace/dotfiles
cd ~/workspace/dotfiles
```

### 3. Install Homebrew
Install the package manager if not already present:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 4. Install Packages
Install all CLI tools, GUI apps, and fonts defined in the `Brewfile`:
```bash
brew bundle
```

### 5. Run Dotbot Install
The `./install` script symlinks configurations and runs bootstrap commands:
```bash
./install
```

This script performs the following actions:
- Cleans dead symlinks from your home directory
- Symlinks all configuration files (Fish, Ghostty, LazyVim, Starship, etc.)
- Installs language runtimes via `mise`
- Bootstraps the Fisher plugin manager and installs Fish plugins
- Runs the Google Cloud SDK initializer

### 6. Local Git Identity
Run the helper script to set up your GPG signing key:
```bash
scripts/setup_git_local.sh
```
This creates `~/.gitconfig.local`, which is ignored by git to keep your private signing keys out of the repository.

### 7. macOS Defaults (Optional)
Apply system-level preferences (Dock, Finder, Keyboard, etc.):
```bash
sh .macos
```
**Note:** This requires granting **Full Disk Access** to your terminal in System Settings.

### 8. Restart
Restart your terminal or open Ghostty to start using the new setup.

## Syncing Changes

To pull updates onto another machine, run:
```bash
cd ~/workspace/dotfiles
git pull
./install
```

If the `Brewfile` or `.tool-versions` changed, run the following:
```bash
# For new Homebrew packages
brew bundle

# For new language runtimes
mise install
```

## Repository Structure

| File / Directory | Description |
| :--- | :--- |
| `install.conf.yaml` | Dotbot configuration (the source of truth for symlinks) |
| `Brewfile` | Declarative list of Homebrew packages and casks |
| `ghostty_config` | Native Ghostty terminal configuration |
| `fish_config.fish` | Main Fish shell configuration and environment variables |
| `fish_functions/` | Custom Fish functions (git aliases, utility helpers) |
| `nvim/` | LazyVim configuration directory |
| `starship.toml` | Starship prompt theme configuration |
| `global_gitconfig` | Base git configuration (copied to ~/.gitconfig) |
| `.macos` | Extensive macOS system defaults script |

## Key Conventions

- **Git Config**: `global_gitconfig` is **copied** to `~/.gitconfig`, not symlinked. Edits made directly to `~/.gitconfig` will not be reflected back to the repo. Use `~/.gitconfig.local` for machine-specific overrides.
- **GPG Signing**: All commits are configured to require GPG signing. Ensure your signing key is set in `~/.gitconfig.local`.
- **Fish Recursion**: Custom git functions in `fish_functions/` use `command git` instead of `git` to avoid infinite recursion.
- **Machine Overrides**: `fish_config.fish` automatically sources `~/.config/fish/config-extension.fish` if it exists. Use this for environment variables or paths that shouldn't be committed.
- **Submodules**: The `dotbot/` directory is a git submodule. Do not edit it directly. Update it using `git submodule update --remote dotbot`.

## Maintenance

### Adding a new Dotfile
1. Create the file in the repository root.
2. Add the mapping to the `link:` section in `install.conf.yaml`.
3. Run `./install`.

### Adding a new Brew package
1. Add the package to `Brewfile`.
2. Run `brew bundle`.

### Adding a new Shell function
1. Create a new `.fish` file in `fish_functions/`.
2. Follow the pattern: `function name --description 'desc'`.
3. Run `./install` to create the symlink.
