# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-11
**Commit:** 2067e09
**Branch:** master

## OVERVIEW

Personal macOS (Apple Silicon) development environment managed by **Dotbot** (git submodule). Ghostty terminal, Fish shell, Starship prompt, LazyVim (Neovim), GPG-signed git, multi-language runtimes via mise.

## STRUCTURE

```
dotfiles/
├── install                    # Entrypoint — runs Dotbot with install.conf.yaml
├── install.conf.yaml          # Source of truth: symlinks, shell commands, cleanup
├── dotbot/                    # Dotbot submodule (DO NOT EDIT)
│
├── fish_config.fish           # Fish shell → ~/.config/fish/config.fish
├── fish_plugins               # Fisher plugins: fisher, sponge, fzf
├── fish_functions/            # 16 Fish functions → ~/.config/fish/functions/
│   ├── g*.fish (14)           # Git aliases (g, ga, gaa, gaac, gc, gco, gd, gdgb, gfap, gl, gph, gphf, gpl, groad, gs)
│   └── vim.fish              # vim → nvim redirect
│
├── nvim/                      # LazyVim config → ~/.config/nvim/ (directory symlink)
│   ├── init.lua               # Entry: require("config.lazy")
│   ├── lua/config/lazy.lua    # Plugin manager + language extras (Elixir, Python, Ruby, TS)
│   ├── lua/config/options.lua # Sonokai theme, 2-space tabs, relative numbers, clipboard
│   ├── lua/config/keymaps.lua # Spacemacs-style leader+l for LSP actions
│   └── lua/plugins/colorscheme.lua  # Sonokai colorscheme setup
│
├── ghostty_config             # Ghostty terminal → ~/.config/ghostty/config
├── starship.toml              # Starship prompt → ~/.config/starship.toml
├── opencode_config.json       # OpenCode → ~/.config/opencode/opencode.json
├── opencode_oh_my_opencode.json # OMO agents/models → ~/.config/opencode/oh-my-opencode.json
│
├── global_gitconfig           # Git config (COPIED, not linked) → ~/.gitconfig
├── global_gitignore           # Git ignore → ~/.gitignore_global
├── gnupg_gpg.conf             # GPG config → ~/.gnupg/gpg.conf
├── gnupg_gpg_agent.conf       # GPG agent → ~/.gnupg/gpg-agent.conf
│
├── Brewfile                   # Declarative Homebrew packages (brew bundle)
├── .macos                     # macOS defaults script (sudo + Full Disk Access required)
├── .tool-versions             # mise runtime versions → ~/.tool-versions
├── scripts/setup_git_local.sh # Interactive GPG signing key setup
├── init_gcloud.sh             # GCP SDK + kubectl init (interactive)
└── fix_gpg_home_permission.sh # GPG dir permission fix
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add new dotfile | `install.conf.yaml` → `link:` section | Create file at root, add symlink mapping |
| Add new shell function | `fish_functions/*.fish` | Pattern: `function name --description 'desc'` + `command <tool> $argv` |
| Add brew package | `Brewfile` | `brew "pkg"` or `cask "app"`, run `brew bundle` |
| Change macOS defaults | `.macos` | `defaults write` — requires Full Disk Access + sudo |
| Add language runtime | `.tool-versions` + `Brewfile` | Add build deps to Brewfile, version to .tool-versions, run `mise install` |
| Change shell setup | `fish_config.fish` | PATH, env vars, tool init (mise, starship, zoxide) |
| Add install step | `install.conf.yaml` → `shell:` section | Runs sequentially during `./install` |
| Change terminal look | `ghostty_config` | Sonokai theme, Hack Nerd Font 16pt, fullscreen |
| Change prompt | `starship.toml` | Minimal config, many modules disabled |
| Change editor config | `nvim/lua/config/options.lua` | LazyVim options |
| Add editor plugin | `nvim/lua/plugins/*.lua` | Return plugin spec table |
| Add editor language | `nvim/lua/config/lazy.lua` | `{ import = "lazyvim.plugins.extras.lang.<name>" }` |
| Add editor keymap | `nvim/lua/config/keymaps.lua` | `vim.keymap.set(...)`, leader+l group for LSP |
| Change git config | `global_gitconfig` | NOTE: COPIED by install script, not symlinked |
| Machine-local git overrides | `~/.gitconfig.local` | Created by `scripts/setup_git_local.sh`, NOT in repo |
| Change OpenCode agents/models | `opencode_oh_my_opencode.json` | Symlinked — changes reflect immediately |

## CONVENTIONS

- **Flat file naming**: Root-level configs prefixed by tool name (`fish_config.fish`, `gnupg_gpg.conf`, `ghostty_config`)
- **Dotbot manages all symlinks**: Never manually symlink — add to `install.conf.yaml` `link:` section
- **Git config is COPIED not linked**: `cp global_gitconfig ~/.gitconfig` — edits to `~/.gitconfig` won't reflect back
- **Fish functions use `command git`**: Not `git` directly — prevents infinite Fish recursion
- **Fish functions follow 3-line pattern**: `function name --description 'desc'` / `command git subcmd $argv` / `end`
- **Fish is the only interactive shell**: Automation scripts use `#!/usr/bin/env bash`
- **GPG signs all commits**: Enforced via `global_gitconfig` → `commit.gpgsign = true`
- **vim always means nvim**: `fish_functions/vim.fish` redirects, `EDITOR=nvim` in fish_config
- **Extension point**: `fish_config.fish` sources `~/.config/fish/config-extension.fish` if it exists — machine-local overrides
- **Sonokai everywhere**: Ghostty theme, Neovim colorscheme — consistent visual identity
- **Rebase-pull by default**: `pull.rebase = true`, `rebase.autoStash = true` in git config
- **Delta for diffs**: Syntax-highlighted diffs in git, with navigate and line numbers

## ANTI-PATTERNS

- **DO NOT edit `dotbot/`** — Git submodule, vendor code. Update: `git submodule update --remote dotbot`
- **DO NOT manually symlink** — Use `install.conf.yaml` link section
- **DO NOT add secrets** — No .env, tokens, API keys. Signing key goes in `~/.gitconfig.local` (not in repo)
- **DO NOT use `git` directly in fish functions** — Use `command git` to prevent infinite recursion
- **`groad` rewrites git history** — `rebase --exec` resetting commit dates. Dangerous in shared repos
- **`gdgb` force-deletes branches** — `git branch -D` via pipeline, irreversible without reflog
- **`gphf` ignores arguments** — Hardcoded `push --force-with-lease` with no `$argv` passthrough
- **`.macos` requires Full Disk Access** — Will fail with permission errors without it

## FISH FUNCTIONS REFERENCE

| Function | Wraps | Notes |
|----------|-------|-------|
| `g` | `git $argv` | Base git alias |
| `ga` | `git add $argv` | |
| `gaa` | `git add . $argv` | Adds all |
| `gaac` | `git add .` + `git commit $argv` | Composite — only commit gets $argv |
| `gc` | `git commit $argv` | |
| `gco` | `git checkout $argv` | |
| `gd` | `git diff $argv` | |
| `gdgb` | Pipeline: branch -vv → grep gone → branch -D | ⚠️ Force deletes gone branches |
| `gfap` | `git fetch --all --prune $argv` | |
| `gl` | `git log $argv` | |
| `gph` | `git push $argv` | |
| `gphf` | `git push --force-with-lease` | ⚠️ No $argv — can't specify remote/branch |
| `gpl` | `git pull $argv` | |
| `groad` | `rebase --exec 'commit --amend --date=now'` | ⚠️ Rewrites history — dangerous |
| `gs` | `git status $argv` | |
| `vim` | `nvim $argv` | Editor redirect |

## INSTALL FLOW

```
./install
  ├── Phase 1: Clean stale symlinks (~/  ~/.config  ~/.config/nvim  ~/.gnupg)
  ├── Phase 2: Create symlinks (all configs → home directory)
  └── Phase 3: Shell commands (sequential, stops on error)
       1. sh .macos                          # macOS defaults (sudo, Full Disk Access)
       2. cp global_gitconfig ~/.gitconfig   # Copy git config (not symlink!)
       3. sh scripts/setup_git_local.sh      # Interactive: GPG signing key → ~/.gitconfig.local
       4. Homebrew bootstrap                 # Install Homebrew if missing
       5. brew bundle --file=Brewfile        # Install all packages
       6. mise install                       # Install language runtimes from .tool-versions
       7. Fisher bootstrap                   # Install Fisher plugin manager
       8. fisher update                      # Install Fish plugins from fish_plugins
       9. sh init_gcloud.sh                  # Interactive: GCP SDK init
      10. git submodule sync --recursive     # Sync submodule URLs
      11. sh fix_gpg_home_permission.sh      # Fix GPG dir permissions
```

## CROSS-REFERENCES

- **GPG chain**: `fish_config.fish` (GPG_TTY + SSH_AUTH_SOCK + agent launch) → `global_gitconfig` (gpgsign=true) → `scripts/setup_git_local.sh` (signing key) → `gnupg_gpg_agent.conf` (pinentry-mac, SSH support)
- **Editor chain**: `fish_config.fish` (EDITOR=nvim) → `global_gitconfig` (core.editor=nvim) → `ghostty_config` (unconsumed Ctrl+hjkl for Neovim, scrollback via $EDITOR)
- **Theme chain**: `ghostty_config` (theme=Sonokai) → `nvim/lua/config/options.lua` (sonokai_style) → `nvim/lua/plugins/colorscheme.lua` (sonokai plugin)

## COMMANDS

```bash
./install                              # Full setup (first time or sync)
brew bundle                            # Install/update Homebrew packages
mise install                           # Install language runtimes
git submodule update --remote dotbot   # Update Dotbot submodule
```

## NOTES

- **macOS Apple Silicon only**: Homebrew at `/opt/homebrew/`, no Linux support
- **Ghostty is primary terminal**: Launches fish, fullscreen, Sonokai theme, Hack Nerd Font 16pt
- **Ghostty quick terminal**: `Cmd+`` toggles dropdown terminal from anywhere (replaces macOS window cycling)
- **Ghostty splits**: `Cmd+D` / `Cmd+Shift+D` for horizontal/vertical, vim-style Ctrl+hjkl navigation
- **LazyVim extras**: Elixir, Python, Ruby, TypeScript language support enabled
- **LSP keymaps**: `<leader>l` group (a=code action, r=rename, f=format, d=diagnostic) alongside LazyVim's `<leader>c`
- **Runtime versions**: Erlang latest, Elixir latest, Node 24.12.0, Python 3.12.11, Ruby 3.1.3
- **Modern CLI aliases**: `ls`→eza, `cat`→bat, `top`→btop, `lg`→lazygit (conditional on install in fish_config)
- **Fisher plugins**: fisher (manager), sponge (clean history of failed commands), fzf (fuzzy finder)
- **OpenCode agents**: sisyphus/prometheus/metis use claude-opus-4.6, explore uses haiku-4.5, visual tasks use gemini-3.1-pro
- **Podman uses libkrun**: Set via `CONTAINERS_MACHINE_PROVIDER` in fish_config
- **pnpm on PATH**: `~/.pnpm` added in fish_config
- **Erlang build**: Docs enabled (`KERL_BUILD_DOCS=yes`), JIT disabled (`--disable-jit`)
- **Python venvs**: In-project (`PIPENV_VENV_IN_PROJECT=1`)
