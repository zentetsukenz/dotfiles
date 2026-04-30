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
Run the helper script to set up your SSH signing key:
```bash
scripts/setup_git_local.sh
```
This creates `~/.gitconfig.local`, which is ignored by git to keep your private SSH signing keys out of the repository.

### 7. macOS Defaults (Optional)
Apply system-level preferences (Dock, Finder, Keyboard, etc.):
```bash
sh macos/apply.sh
```
Use `--dry-run` to preview changes without applying them, or `--fresh-install` to also run destructive one-time operations (Dock wipe, Spotlight reindex).

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

If the `Brewfile` or `mise_config.toml` changed, run the following:
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
| `opencode/` | OpenCode + OMO configuration, global AGENTS.md, and custom command templates |
| `global_gitconfig` | Base git configuration (copied to ~/.gitconfig) |
| `macos/` | Modular macOS defaults — `apply.sh` orchestrator + 8 domain modules |

## Key Conventions

- **Git Config**: `global_gitconfig` is **copied** to `~/.gitconfig`, not symlinked. Edits made directly to `~/.gitconfig` will not be reflected back to the repo. Use `~/.gitconfig.local` for machine-specific overrides.
- **SSH Signing**: All commits are configured to require SSH signing. Ensure your SSH signing key path is set in `~/.gitconfig.local` (e.g., `signingKey = ~/.ssh/id_ed25519_sk.pub`).
- **Fish Recursion**: Custom git functions in `fish_functions/` use `command git` instead of `git` to avoid infinite recursion.
- **Machine Overrides**: `fish_config.fish` automatically sources `~/.config/fish/config-extension.fish` if it exists. Use this for environment variables or paths that shouldn't be committed.
- **Submodules**: The `dotbot/` directory is a git submodule. Do not edit it directly. Update it using `git submodule update --remote dotbot`.

## OpenCode + OMO Notes

- **Default agent is `prometheus`**: Every TUI session and CLI invocation starts in planning mode. Use `opencode --agent build` or `opencode --agent quick` for one-shot tasks that don't need a plan.
- **GitHub Copilot precondition**: Run `gh auth login` once per machine before using opencode. `gh` is installed via Brewfile.
- **OpenCode CLI install**: No canonical Homebrew formula exists at time of writing. Install manually: `curl -fsSL https://opencode.ai/install | bash`. Run this before `./install`.
- **Theme inheritance**: TUI uses `theme: system` in `opencode/tui.json` — colors are inherited from your terminal palette. Ghostty with the Sonokai theme produces Sonokai-aligned colors automatically; different terminals will show their own palette.
- **Permissions**: `edit` is auto-approved. `bash` allows a curated set of read-only commands without prompting (ls, cat, grep, git status/diff/log, package list queries, modern viewers, read-only filters); all other bash commands require approval. `webfetch` requires explicit approval per call. See `opencode/opencode.json` `permission.bash` for the full allowlist.
- **serena MCP**: Semantic code search, auto-loaded. Use for symbol navigation across files.
- **memory MCP**: Long-term knowledge graph at `~/.config/opencode/memory.json`. Governed by `MEMORY-POLICY.md`. Write access: Prometheus + Mnemosyne only.
- **Mnemosyne agent**: Retro agent. Invoke via `/retro` or `opencode --agent mnemosyne`. Writes to `harness-journal/` only.
- **/retro command**: Runs a harness retrospective. Produces `harness-journal/retro-{date}.md`.


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
