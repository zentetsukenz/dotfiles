# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-06
**Commit:** 4901252
**Branch:** master

## OVERVIEW

Personal macOS development environment managed by **Dotbot** (git submodule). Fish shell, Neovim, Tmux, Alacritty, GPG signing, multi-language runtimes via ASDF.

## STRUCTURE

```
dotfiles/
├── install                    # Entrypoint — runs Dotbot with install.conf.yaml
├── install.conf.yaml          # Dotbot config: symlinks, shell commands, cleanup
├── dotbot/                    # Dotbot submodule (DO NOT EDIT — vendor code)
│
├── fish_config.fish           # Fish shell config → ~/.config/fish/config.fish
├── fish_plugins               # Fisher plugin list (bobthefish, fzf)
├── fish_functions/            # 17 Fish functions → ~/.config/fish/functions/
│   ├── g*.fish                # Git aliases (g, ga, gaa, gaac, gc, gco, gd, gdgb, gfap, gl, gph, gphf, gpl, groad, gs)
│   ├── vim.fish               # vim → nvim redirect
│   └── emptytrash.fish        # macOS trash cleanup (uses sudo)
│
├── nvim_init.vim              # Neovim config → ~/.config/nvim/init.vim
├── .tmux.conf                 # Tmux config → ~/.tmux.conf
├── alacritty.toml             # Alacritty terminal → ~/.config/alacritty/alacritty.toml
├── opencode_config.json           # OpenCode config → ~/.config/opencode/opencode.json
├── opencode_oh_my_opencode.json   # Oh-My-OpenCode config → ~/.config/opencode/oh-my-opencode.json
│
├── global_gitconfig           # Git config (COPIED, not linked) → ~/.gitconfig
├── global_gitignore           # Git ignore → ~/.gitignore_global
├── gnupg_gpg.conf             # GPG config → ~/.gnupg/gpg.conf
├── gnupg_gpg_agent.conf       # GPG agent → ~/.gnupg/gpg-agent.conf
│
├── .macos                     # 800-line macOS defaults script (sudo required)
├── brew.sh                    # Homebrew packages + language runtimes
├── tmux.sh                    # TPM installer (idempotent clone)
├── install_powerline_fonts.sh # Powerline fonts installer
├── init_gcloud.sh             # GCP SDK + kubectl init
├── fix_gpg_home_permission.sh # GPG dir permission fix
└── .tool-versions             # ASDF versions → ~/.tool-versions
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add new dotfile | `install.conf.yaml` → `link:` section | Create file at root, add symlink mapping |
| Add new shell function | `fish_functions/*.fish` | Pattern: `function name --description 'desc'` |
| Add brew package | `brew.sh` | Append `brew install <pkg>` |
| Change macOS defaults | `.macos` | Uses `defaults write` — requires Full Disk Access |
| Add language runtime | `.tool-versions` + `brew.sh` | Add asdf plugin in brew.sh, version in .tool-versions |
| Change shell setup | `fish_config.fish` | PATH, env vars, tool init |
| Add install step | `install.conf.yaml` → `shell:` section | Runs in order during `./install` |
| Change tmux behavior | `.tmux.conf` | Prefix is Ctrl-A, uses TPM plugins |
| Change editor config | `nvim_init.vim` | vim-plug, leader is comma |
| Change terminal look | `alacritty.toml` | Font: Hack 16pt, fullscreen startup |
| Change OpenCode config | `opencode_config.json`, `opencode_oh_my_opencode.json` | Symlinked to `~/.config/opencode/` |
| Change git identity | `global_gitconfig` | NOTE: copied (not linked) by install script |

## CONVENTIONS

- **Flat file organization**: All configs at repo root, prefixed by tool name (e.g., `fish_config.fish`, `gnupg_gpg.conf`)
- **Dotbot manages symlinks**: Never manually symlink — add to `install.conf.yaml`
- **Git config is COPIED not linked**: `cp global_gitconfig ~/.gitconfig` (line 38 of install.conf.yaml) — edits to ~/.gitconfig won't reflect back
- **Fish functions follow pattern**: `function <name> --description '<desc>'` + `command <tool> $argv` — 2-4 lines each
- **Fish is the only shell**: No zsh/bash configs for interactive use. Automation scripts use `#!/usr/bin/env bash`
- **All git functions use `command git`**: Not `git` directly — avoids recursive function calls in Fish
- **GPG signs all commits**: Enforced via `global_gitconfig` → `commit.gpgsign = true`
- **vim always means nvim**: `fish_functions/vim.fish` redirects `vim` → `nvim`
- **Extension point**: `fish_config.fish` line 68 sources `~/.config/fish/config-extension.fish` if it exists — use for machine-local overrides

## ANTI-PATTERNS

- **DO NOT edit `dotbot/`** — Git submodule, vendor code. Update with `git submodule update --remote dotbot`
- **DO NOT manually symlink** — Use `install.conf.yaml` link section
- **DO NOT add secrets** — No .env, tokens, or API keys. GPG signing key reference is a placeholder (`machine-signing-key`)
- **DO NOT use `git` directly in fish functions** — Use `command git` to prevent infinite recursion
- **`brew.sh` line 73 has a bug**: Duplicate `asdf install elixir` commands concatenated on one line
- **`emptytrash.fish` uses `sudo rm -rfv`** — Destructive, elevated. Be cautious modifying
- **`groad` rewrites git history** — `filter-branch` on commit dates. Dangerous in shared repos

## COMMANDS

```bash
# Full system setup (first time or reset)
./install

# Update dotbot submodule
git submodule update --remote dotbot

# After editing install.conf.yaml (re-run just dotbot)
./install

# After editing brew.sh (manual run)
sh brew.sh
```

## NOTES

- **macOS-only**: Homebrew paths assume Apple Silicon (`/opt/homebrew/`). No Linux support
- **Alacritty launches fish**: Configured in `alacritty.toml` → `/opt/homebrew/bin/fish --login`
- **Tmux prefix is Ctrl-A** (not default Ctrl-B), vi mode keys, mouse enabled
- **Neovim hardmode enabled by default**: Arrow keys disabled. Toggle with `,h`
- **ASDF runtimes**: Erlang 24.2.1, Elixir 1.13.3, Node 24.12.0, PHP 8.1.3, Python 3.12.11, Ruby 3.1.3
- **OpenCode + Antigravity on PATH**: `~/.opencode/bin` and `~/.antigravity/antigravity/bin` added in fish_config
- **OpenCode + OMO configs are symlinked**: Unlike git config (which is copied), these are live symlinks. Runtime artifacts (`node_modules/`, `package.json`) in `~/.config/opencode/` are managed by OMO, not dotfiles
- **Podman uses libkrun**: `CONTAINERS_MACHINE_PROVIDER=libkrun` set in fish_config
- **VSCode shell integration**: Auto-sourced when running inside VS Code terminal
